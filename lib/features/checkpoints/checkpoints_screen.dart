import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:checkpoint/backend/storages/checkpoint_storage.dart';
import 'package:checkpoint/features/checkpoints/search_checkpoint_screen.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'widgets/checkpoint_widget.dart';

class CheckpointsScreen extends StatelessWidget with WatchItMixin {
  const CheckpointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckpointStorage checkpointStorage = watchValue(
        (CheckpointRepository checkpointRepository) =>
            checkpointRepository.checkpointStorageNotifier);
    final String selectedLanguage = watchValue(
        (CheckpointRepository checkpointRepository) =>
            checkpointRepository.checkpointLanguageNotifier);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Checkpoints'),
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
                    builder: (context) => const SearchCheckpointScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            PopupMenuButton<Image>(
              icon: Image.asset(
                "assets/images/${selectedLanguage}Flag.png",
                height: 20.0,
              ),
              color: Colors.black,
              position: PopupMenuPosition.under,
              constraints: const BoxConstraints(
                maxWidth: 60.0,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    di<CheckpointRepository>()
                        .checkpointLanguageNotifier
                        .value = "en";
                  },
                  child: Image.asset(
                    height: 20.0,
                    "assets/images/enFlag.png",
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    di<CheckpointRepository>()
                        .checkpointLanguageNotifier
                        .value = "tr";
                  },
                  child: Image.asset(
                    height: 20.0,
                    "assets/images/trFlag.png",
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    di<CheckpointRepository>()
                        .checkpointLanguageNotifier
                        .value = "de";
                  },
                  child: Image.asset(
                    height: 20.0,
                    "assets/images/deFlag.png",
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    di<CheckpointRepository>()
                        .checkpointLanguageNotifier
                        .value = "fr";
                  },
                  child: Image.asset(
                    height: 20.0,
                    "assets/images/frFlag.png",
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    di<CheckpointRepository>()
                        .checkpointLanguageNotifier
                        .value = "es";
                  },
                  child: Image.asset(
                    height: 20.0,
                    "assets/images/esFlag.png",
                  ),
                ),
              ],
            ),
          ],
        ),
        // StreamBuilder(
        //   stream: searcher.responses,
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) {
        //       return const SliverToBoxAdapter(
        //           child: Center(child: CircularProgressIndicator()));
        //     }
        //     print(snapshot.data!.hits);
        //
        //     return SliverList.builder(
        //       itemCount: snapshot.data!.hits.length,
        //       itemBuilder: (context, index) {
        //         print(snapshot.data!.hits[index].keys);
        //         print(snapshot.data!.hits[index]["_geoloc"]);
        //         return CheckpointWidget(
        //           checkpoint: Checkpoint.fromHit(snapshot.data!.hits[index]),
        //           languageCode: selectedLanguage,
        //         );
        //       },
        //     );
        //   },
        // ),
        SliverList.list(
          children: checkpointStorage.checkpoints
              .map(
                (e) => CheckpointWidget(
                    checkpoint: e, languageCode: selectedLanguage),
              )
              .toList(),
        ),
      ],
    );
  }
}
