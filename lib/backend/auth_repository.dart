import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_command/flutter_command.dart';

import '../models/user.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) {
    _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
    signUpCommand = Command.createAsyncNoResult(
      ((String email, String password) userRecord) async {
        await _signUpWithEmailAndPassword(
          email: userRecord.$1,
          password: userRecord.$2,
        );
      },
      errorFilter: const ErrorHandlerLocalAndGlobal(),
    );
    loginCommand = Command.createAsyncNoResult(
      ((String email, String password) userRecord) async {
        await _logInWithEmailAndPassword(
          email: userRecord.$1,
          password: userRecord.$2,
        );
      },
      errorFilter: const ErrorHandlerLocalAndGlobal(),
    );
    logOutCommand = Command.createAsyncNoParamNoResult(
      () async {
        await _logOut();
      },
    );

    signUpCommand.errors.listen((err, _) {});
    loginCommand.errors.listen((err, _) {});
    logOutCommand.errors.listen((err, _) {});
  }

  late firebase_auth.FirebaseAuth _firebaseAuth;
  late Command<(String email, String password), void> signUpCommand;
  late Command<(String email, String password), void> loginCommand;
  late Command logOutCommand;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      return user;
    });
  }

  User get currentUser {
    return firebase_auth.FirebaseAuth.instance.currentUser?.toUser ??
        User.empty;
  }

  Future<void> _signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> _logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> _logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}

class SignUpWithEmailAndPasswordFailure implements Exception {
  SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]) {
    time = DateTime.now();
  }

  final String message;
  late DateTime time;

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) =>
      other is SignUpWithEmailAndPasswordFailure && other.hashCode == hashCode;
  @override
  int get hashCode => message.hashCode + time.hashCode;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]) {
    time = DateTime.now();
  }

  final String message;
  late DateTime time;

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return LogInWithEmailAndPasswordFailure();
    }
  }
  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) =>
      other is SignUpWithEmailAndPasswordFailure && other.hashCode == hashCode;
  @override
  int get hashCode => message.hashCode + time.hashCode;
}

class LogOutFailure implements Exception {}
