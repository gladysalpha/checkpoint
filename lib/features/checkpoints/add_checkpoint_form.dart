import 'dart:io';

import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:checkpoint/models/checkpoint.dart';
import 'package:checkpoint/models/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watch_it/watch_it.dart';

import '../../backend/main_navigator_manager.dart';
import '../../widgets/circular_progress_dialog.dart';
import '../map/map_screen.dart';

class AddCheckpointScreen extends StatelessWidget with WatchItMixin {
  AddCheckpointScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ValueNotifier<XFile?> selectedImageNotifier =
      ValueNotifier<XFile?>(null);

  final ImagePicker imagePicker = ImagePicker();

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
          checkpointRepository.createNewCheckpointCommand.isExecuting,
    );
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('New Checkpoint'),
            background: Container(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LocationSelectionPage(
                        onSelection: (LatLng location) async {
                          await di<CheckpointRepository>()
                              .createNewCheckpointCommand
                              .executeWithFuture(
                                Checkpoint(
                                  id: "",
                                  title: _titleController.text,
                                  desc: _descController.text,
                                  photo: selectedImageNotifier.value!.path,
                                  owner: di<AuthenticationRepository>()
                                      .currentUser,
                                  latLng: location,
                                  translatedContent: {},
                                ).toDocumentData(),
                              );
                          if (context.mounted) {
                            Navigator.pop(context);
                            di<MainNavigatorManager>()
                                .goToCommand(NavItem.checkpoints);
                          }
                        },
                      );
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              highlightColor: Colors.white24,
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 32.0,
            ),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: selectedImageNotifier,
                    builder: (_, selectedImage, __) {
                      return InkWell(
                        onTap: () async {
                          selectedImageNotifier.value = await imagePicker
                              .pickImage(source: ImageSource.gallery);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              image: selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(
                                          selectedImage.path,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    )
                                  : null,
                            ),
                            child: Container(
                              height: 400.0,
                              alignment: Alignment.center,
                              child: selectedImage != null
                                  ? null
                                  : const Text(
                                      "Select your checkpoint photo!",
                                    ),
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  cursorColor: Colors.black,
                  decoration:
                      const InputDecoration(hintText: "Checkpoint Title"),
                  controller: _titleController,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: "Checkpoint Description"),
                  cursorColor: Colors.black,
                  controller: _descController,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LocationSelectionPage extends StatelessWidget {
  const LocationSelectionPage({super.key, required this.onSelection});
  final ValueChanged<LatLng> onSelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onTap: onSelection,
      ),
    );
  }
}
