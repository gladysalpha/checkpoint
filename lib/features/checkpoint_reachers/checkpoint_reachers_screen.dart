import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:checkpoint/features/checkpoint_reachers/widgets/post_widget.dart';
import 'package:checkpoint/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'widgets/starter_post_widget.dart';

class CheckpointReachersScreen extends StatelessWidget {
  const CheckpointReachersScreen({super.key, required this.checkpoint});
  final Checkpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Checkpoint Reachers'),
              background: Container(
                color: Colors.black,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StarterPostWidget(
              checkpoint: checkpoint,
            ),
          ),
          ValueListenableBuilder(
            valueListenable:
                di<CheckpointRepository>().getCheckpointPostsCommand.results,
            builder: (context, getCheckpointPostsCommandResult, _) {
              if (getCheckpointPostsCommandResult.isExecuting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return SliverList.builder(
                itemCount: getCheckpointPostsCommandResult.data!.length,
                itemBuilder: (context, index) => PostWidget(
                  checkpoint: checkpoint,
                  post: getCheckpointPostsCommandResult.data![index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
