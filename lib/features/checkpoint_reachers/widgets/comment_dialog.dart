import 'package:flutter/material.dart';

class CommentDialog extends StatelessWidget {
  CommentDialog({
    super.key,
  });
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: TextField(
        controller: _commentController,
        decoration: const InputDecoration(
          hintText: "Write a comment",
        ),
        onSubmitted: (commentText) {
          Navigator.pop(context, commentText);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, _commentController.text);
          },
          child: const Text("Send Post"),
        ),
      ],
    );
  }
}
