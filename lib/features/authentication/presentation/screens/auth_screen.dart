import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praxis/features/authentication/presentation/screens/signup_screen.dart';
import 'package:praxis/features/authentication/presentation/screens/home_screen.dart';

class AuthenticationFlowScreen extends StatelessWidget {
  const AuthenticationFlowScreen({super.key});
  static String id = 'main_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignupScreen();
          }
        },
      ),
    );
  }
}
