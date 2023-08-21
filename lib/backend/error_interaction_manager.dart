import 'package:flutter/material.dart';

class ErrorInteractionManager {
  ValueNotifier<Exception> lastAuthError =
      ValueNotifier<Exception>(Exception());
  void handleAuthErrors(Exception exception) {
    lastAuthError.value = exception;
  }
}
