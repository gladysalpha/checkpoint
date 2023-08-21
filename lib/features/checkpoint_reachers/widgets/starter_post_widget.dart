import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:checkpoint/features/checkpoint_reachers/widgets/comment_dialog.dart';
import 'package:checkpoint/models/post.dart';
import 'package:checkpoint/widgets/circular_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/checkpoint.dart';

class StarterPostWidget extends StatelessWidget with WatchItMixin {
  const StarterPostWidget({super.key, required this.checkpoint});

  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    registerHandler(
      handler: (context, isExecuting, cancel) async {
        if (isExecuting) {
          showDialog(
            context: context,
            builder: (context) => WillPopScope(
              child: circularProgressDialog,
              onWillPop: () => Future.value(false),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      },
      select: (CheckpointRepository checkpointRepository) =>
          checkpointRepository.createNewPostCommand.isExecuting,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 90,
                  height: 160.0,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        checkpoint.photo,
                      ),
                      colorFilter: const ColorFilter.mode(
                        Colors.black26,
                        BlendMode.colorBurn,
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: checkpoint.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          children: [
                            TextSpan(
                              text: "\n${checkpoint.desc}",
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationDisplayMap(
                                  checkpoint: checkpoint,
                                ),
                              ),
                            );
                          },
                          child: const Text("See location"),
                        ),
                        TextButton(
                          onPressed: () async {
                            String? imagePath = (await ImagePicker()
                                    .pickImage(source: ImageSource.gallery))
                                ?.path;

                            if (imagePath == null) return;

                            if (!context.mounted) return;

                            String commentText = await showDialog(
                              context: context,
                              builder: (context) => CommentDialog(),
                            );

                            if (commentText.isEmpty) return;

                            await di<CheckpointRepository>()
                                .createNewPostCommand
                                .executeWithFuture(
                              (
                                checkpoint,
                                Post(
                                  id: "",
                                  comment: commentText,
                                  photo: imagePath,
                                  owner: di<AuthenticationRepository>()
                                      .currentUser,
                                ).toDocumentData(),
                              ),
                            );
                            di<CheckpointRepository>()
                                .getCheckpointPostsCommand
                                .execute(checkpoint);
                          },
                          child: const Text("Send post"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LocationDisplayMap extends StatelessWidget {
  const LocationDisplayMap({
    super.key,
    required this.checkpoint,
  });
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: checkpoint.latLng,
          zoom: 17,
        ),
        markers: {
          checkpoint.toMarker(
              icon: di<CheckpointRepository>().checkpointMarker),
        },
      ),
    );
  }
}
