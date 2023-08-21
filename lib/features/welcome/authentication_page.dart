import 'package:checkpoint/backend/auth_repository.dart';
import 'package:checkpoint/backend/error_interaction_manager.dart';
import 'package:checkpoint/enums.dart';
import 'package:checkpoint/features/main/main_screen.dart';
import 'package:checkpoint/models/user.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key, required this.authType});
  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: "welcomeDraw",
              child: Image.asset(
                "assets/images/welcomeDraw.png",
              ),
            ),
            _AuthTitle(authType),
            const SizedBox(
              height: 50.0,
            ),
            _AuthForm(
              authType,
            ),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTitle extends StatelessWidget {
  const _AuthTitle(this.authType);
  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    return Text(
      authType == AuthType.login
          ? "Login to Your Account"
          : "Sign Up For Checkpoint",
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24.0,
        color: Color(0xFF3F3D56),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AuthForm extends StatefulWidget with WatchItStatefulWidgetMixin {
  const _AuthForm(this.authType);
  final AuthType authType;

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    registerStreamHandler(
      select: (AuthenticationRepository authRepo) =>
          authRepo.user.where((event) => event != User.empty),
      handler: (context, value, cancel) {
        if (value.data != User.empty) {
          cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (route) => false,
          );
        }
      },
      initialValue: User.empty,
    );
    registerHandler(
      select: (ErrorInteractionManager m) => m.lastAuthError,
      handler: (context, newValue, cancel) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newValue.toString(),
            ),
          ),
        );
      },
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "E-mail address",
            ),
            controller: _emailController,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            controller: _passwordController,
          ),
        ),
        const SizedBox(
          height: 50.0,
        ),
        _AuthButton(
          widget.authType,
          () {
            switch (widget.authType) {
              case AuthType.signUp:
                di<AuthenticationRepository>()
                    .signUpCommand
                    .execute((_emailController.text, _passwordController.text));
                break;
              case AuthType.login:
                di<AuthenticationRepository>()
                    .loginCommand
                    .execute((_emailController.text, _passwordController.text));
                break;
            }
          },
        ),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton(this.authType, this.onPressed);
  final AuthType authType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size(220.0, 50.0),
              ),
              backgroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFF3F3D56),
              ),
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              )),
          child: Text(
            authType == AuthType.login ? "Login" : "Sign Up",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
