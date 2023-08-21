import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/models/user.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'features/main/main_screen.dart';
import 'features/welcome/welcome_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'CheckPoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFA763),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        useMaterial3: true,
      ),
      home: AuthCheckerWidget(
        authenticatedChild: FutureBuilder<void>(
            future: di.allReady(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return MainScreen();
            }),
        unAuthenticatedChild: const WelcomeScreen(),
      ),
    );
  }
}

class AuthCheckerWidget extends StatelessWidget with WatchItMixin {
  const AuthCheckerWidget(
      {super.key,
      required this.authenticatedChild,
      required this.unAuthenticatedChild});
  final Widget authenticatedChild;
  final Widget unAuthenticatedChild;

  @override
  Widget build(BuildContext context) {
    User? userData = watchStream(
      (AuthenticationRepository authRepo) => authRepo.user,
      initialValue: User.empty,
    ).data;

    return userData != User.empty ? authenticatedChild : unAuthenticatedChild;
  }
}
