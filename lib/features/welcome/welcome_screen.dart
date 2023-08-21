import 'package:checkpoint/enums.dart';
import 'package:checkpoint/features/welcome/authentication_page.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F3D56),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: "welcomeDraw",
            child: Image.asset(
              "assets/images/welcomeDraw.png",
            ),
          ),
          const Text(
            "Welcome to Checkpoint!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              "See challenges on checkpoints, complete the challlenges an share them with everyone! ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen(
                        authType: AuthType.login,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(220.0, 50.0),
                  ),
                ),
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen(
                        authType: AuthType.signUp,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(220.0, 50.0),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
