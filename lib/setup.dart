import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/backend/checkpoint_repository.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:watch_it/watch_it.dart';

import 'backend/error_interaction_manager.dart';
import 'backend/main_navigator_manager.dart';

void setup() {
  di.registerSingleton<MainNavigatorManager>(MainNavigatorManager());
  di.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
  di.registerSingletonAsync<CheckpointRepository>(
    () => CheckpointRepository().init(),
  );
  di.registerSingleton<ErrorInteractionManager>(ErrorInteractionManager());

  Command.globalExceptionHandler = (error, stackTrace) {
    if (error.error is SignUpWithEmailAndPasswordFailure ||
        error.error is LogInWithEmailAndPasswordFailure) {
      di<ErrorInteractionManager>().handleAuthErrors(error.error as Exception);
    }
  };
}
