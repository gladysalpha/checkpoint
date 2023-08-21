import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:checkpoint/features/checkpoints/widgets/checkpoint_widget.dart';
import 'package:checkpoint/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../backend/checkpoint_repository.dart';

class SearchCheckpointScreen extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const SearchCheckpointScreen({super.key});

  @override
  State<SearchCheckpointScreen> createState() => _SearchCheckpointScreenState();
}

class _SearchCheckpointScreenState extends State<SearchCheckpointScreen> {
  final TextEditingController _searchKeyController = TextEditingController();

  @override
  void initState() {
    _searchKeyController.addListener(() {
      di<CheckpointRepository>()
          .searchCheckpointCommand
          .execute(_searchKeyController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String selectedLanguage = watchValue(
        (CheckpointRepository checkpointRepository) =>
            checkpointRepository.checkpointLanguageNotifier);
    final List<Hit> searchResults = watchStream(
        (CheckpointRepository checkpointRepository) =>
            checkpointRepository.algoliaSearcher.responses,
        initialValue: SearchResponse({})).data!.hits;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Search checkpoint'),
              background: Container(
                color: Colors.black,
              ),
            ),
            actions: [
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
          SliverToBoxAdapter(
            child: TextField(
              controller: _searchKeyController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                hintText: "Search checkpoint",
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SliverList.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) => CheckpointWidget(
              checkpoint: Checkpoint.fromHit(
                searchResults[index],
              ),
              languageCode: selectedLanguage,
            ),
          ),
        ],
      ),
    );
  }
}
