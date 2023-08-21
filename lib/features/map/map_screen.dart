import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:checkpoint/backend/storages/checkpoint_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watch_it/watch_it.dart';

import '../checkpoint_reachers/checkpoint_reachers_screen.dart';

const CameraPosition initialCameraPosition = CameraPosition(
  target: LatLng(43.722952, 10.396597),
  zoom: 12,
);

class MapScreen extends StatelessWidget with WatchItMixin {
  MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CheckpointStorage checkpointStorage = watchValue(
        (CheckpointRepository checkpointRepository) =>
            checkpointRepository.checkpointStorageNotifier);

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: checkpointStorage.checkpoints
          .map(
            (e) => e.toMarker(
              icon: di<CheckpointRepository>().checkpointMarker,
              onTap: () {
                di<CheckpointRepository>().getCheckpointPostsCommand.execute(e);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckpointReachersScreen(
                      checkpoint: e,
                    ),
                  ),
                );
              },
            ),
          )
          .toSet(),
    );
  }
}
