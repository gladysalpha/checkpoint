import 'package:checkpoint/models/checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../backend/checkpoint_repository.dart';
import '../../checkpoint_reachers/checkpoint_reachers_screen.dart';

class CheckpointWidget extends StatelessWidget {
  const CheckpointWidget(
      {super.key, required this.checkpoint, required this.languageCode});
  final Checkpoint checkpoint;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        di<CheckpointRepository>()
            .getCheckpointPostsCommand
            .execute(checkpoint);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckpointReachersScreen(
              checkpoint: checkpoint,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              minRadius: 30.0,
              backgroundImage: checkpoint.owner.photo == null
                  ? const AssetImage("assets/images/profilePhoto.png")
                  : NetworkImage(checkpoint.owner.photo!) as ImageProvider,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text.rich(
                      TextSpan(
                        text: languageCode == "en"
                            ? checkpoint.title
                            : checkpoint.translatedContent["title"]
                                [languageCode],
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "\n${languageCode == "en" ? checkpoint.desc : checkpoint.translatedContent["desc"][languageCode]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      height: 400,
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
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Divider(
                    thickness: 2.0,
                    color: Colors.black12,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
