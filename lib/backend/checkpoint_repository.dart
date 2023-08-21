import 'dart:async';
import 'dart:io';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/models/checkpoint.dart';
import 'package:checkpoint/models/post.dart';
import 'package:checkpoint/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_it/watch_it.dart';

import 'storages/checkpoint_storage.dart';

class CheckpointRepository {
  late BitmapDescriptor checkpointMarker;
  late Command<Map<String, dynamic>, void> createNewCheckpointCommand;
  late Command<Checkpoint, List<Post>> getCheckpointPostsCommand;
  late Command<(Checkpoint checkpoint, Map<String, dynamic> data), void>
      createNewPostCommand;
  late Command<String, void> searchCheckpointCommand;

  late ValueNotifier<CheckpointStorage> checkpointStorageNotifier;

  CheckpointRepository() {
    checkpointStorageNotifier = ValueNotifier(CheckpointStorage.empty);

    createNewCheckpointCommand = Command.createAsyncNoResult(
      (Map<String, dynamic> data) async {
        (String downloadUrl, String fullPath) uploadRecord =
            await _uploadCheckpointPhoto(data["photo"]);
        data["photo"] = uploadRecord.$1;
        data["file"] = "gs://checkpoint-24787.appspot.com/${uploadRecord.$2}";
        data["tags"] = await _readAndWriteImageLabels(data["file"]);
        await _createNewCheckpoint(data);
      },
    );
    getCheckpointPostsCommand = Command.createAsync(
      (Checkpoint checkpoint) => _getCheckpointPosts(checkpoint),
      initialValue: [],
    );
    createNewPostCommand = Command.createAsyncNoResult(
      ((Checkpoint checkpoint, Map<String, dynamic> data) userRecord) async {
        (String downloadUrl, String fullPath) uploadRecord =
            await _uploadPostPhoto(userRecord.$2["photo"]);
        userRecord.$2["photo"] = uploadRecord.$1;
        userRecord.$2["file"] =
            "gs://checkpoint-24787.appspot.com/${uploadRecord.$2}";
        userRecord.$2["tags"] =
            await _readAndWriteImageLabels(userRecord.$2["file"]);

        await _createPost(userRecord.$1, userRecord.$2);
      },
    );
    searchCheckpointCommand = Command.createSyncNoResult(
      (String searchKey) {
        algoliaSearcher.query(searchKey);
      },
    );
    searchCheckpointCommand.debounce(
      const Duration(milliseconds: 500),
    );
  }

  final CollectionReference checkpointCollection =
      FirebaseFirestore.instance.collection("checkpoints");
  final CollectionReference imageLabelsCollection =
      FirebaseFirestore.instance.collection("imageLabels");
  final Reference checkpointStorageReference =
      FirebaseStorage.instance.ref("checkpoints");

  //TODO: YOU NEED TO CONNECT WITH YOUR ALGOLIA ACCOUNT

  final HitsSearcher algoliaSearcher = HitsSearcher(
    applicationID: 'your config',
    apiKey: 'your config',
    indexName: 'checkpoint',
  );

  final StreamController checkpointsStreamController = StreamController();
  ValueNotifier<String> checkpointLanguageNotifier =
      ValueNotifier<String>("en");

  Future<CheckpointRepository> init() async {
    await _setCheckpointMarker();
    di<AuthenticationRepository>().user.listen((event) {
      if (checkpointsStreamController.hasListener && event == User.empty) {
        checkpointsStreamController.close();
      } else if (event != User.empty &&
          !checkpointsStreamController.hasListener) {
        checkpointsStreamController.addStream(_checkpoints);
        checkpointsStreamController.stream.listen((event) {
          checkpointStorageNotifier.value =
              checkpointStorageNotifier.value.copyWith(
            checkpoints: event,
          );
        });
      }
    });
    return this;
  }

  Future<void> _setCheckpointMarker() async {
    checkpointMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pinIcon.png",
    );
  }

  Stream<Set<Checkpoint>> get _checkpoints {
    return checkpointCollection
        .orderBy("createdDate", descending: true)
        .snapshots()
        .map<Set<Checkpoint>>((checkpointQuery) {
      Set<Checkpoint> checkpoint = checkpointQuery.docs.map<Checkpoint>(
        (doc) {
          return Checkpoint.fromEntity((doc.data() as Map<String, dynamic>)
            ..addAll(<String, dynamic>{"id": doc.id}));
        },
      ).toSet();
      return checkpoint;
    });
  }

  Future<void> _createNewCheckpoint(Map<String, dynamic> checkpointData) async {
    await checkpointCollection.doc().set(checkpointData
      ..addAll(
        {"createdDate": FieldValue.serverTimestamp()},
      ));
  }

  Future<(String downloadUrl, String fullPath)> _uploadCheckpointPhoto(
      String imagePath) async {
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    await checkpointStorageReference
        .child(name)
        .putData(File(imagePath).readAsBytesSync());

    return (
      await checkpointStorageReference.child(name).getDownloadURL(),
      checkpointStorageReference.child(name).fullPath
    );
  }

  Future<List<Post>> _getCheckpointPosts(Checkpoint checkpoint) async {
    return (await checkpointCollection
            .doc(checkpoint.id)
            .collection("posts")
            .orderBy("createdDate", descending: true)
            .get())
        .docs
        .map((e) =>
            Post.fromEntity(e.data()..addAll(<String, dynamic>{"id": e.id})))
        .toList();
  }

  Future<(String downloadUrl, String fullPath)> _uploadPostPhoto(
      String imagePath) async {
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    await checkpointStorageReference
        .child(name)
        .putData(File(imagePath).readAsBytesSync());

    return (
      await checkpointStorageReference.child(name).getDownloadURL(),
      checkpointStorageReference.child(name).fullPath
    );
  }

  Future<void> _createPost(
      Checkpoint checkpoint, Map<String, dynamic> checkpointData) async {
    await checkpointCollection.doc(checkpoint.id).collection("posts").doc().set(
          checkpointData
            ..addAll(
              {"createdDate": FieldValue.serverTimestamp()},
            ),
        );
  }

  Future<List> _readAndWriteImageLabels(String filePath) async {
    QuerySnapshot<Map<String, dynamic>?> data = await imageLabelsCollection
        .where(
          "file",
          isEqualTo: filePath,
        )
        .get() as QuerySnapshot<Map<String, dynamic>?>;
    if (data.docs.isEmpty) {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      return await _readAndWriteImageLabels(filePath);
    } else {
      return Future.value(data.docs.first.data()!["labels"]);
    }
  }
}
