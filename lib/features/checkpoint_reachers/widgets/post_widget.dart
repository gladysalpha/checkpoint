import 'package:checkpoint/models/checkpoint.dart';
import 'package:flutter/material.dart';

import '../../../models/post.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.checkpoint, required this.post});
  final Checkpoint checkpoint;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            minRadius: 30.0,
            backgroundImage: AssetImage("assets/images/profilePhoto.png"),
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
                      text: checkpoint.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: "\n${post.comment}",
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
                          post.photo,
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
    );
  }
}
