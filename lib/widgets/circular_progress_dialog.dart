import 'package:flutter/material.dart';

const AlertDialog circularProgressDialog = AlertDialog(
  backgroundColor: Colors.transparent,
  elevation: 0.0,
  contentPadding: EdgeInsets.zero,
  insetPadding: EdgeInsets.zero,
  content: Center(
    child: CircularProgressIndicator(
      color: Color(0xFF7200C9),
    ),
  ),
);
