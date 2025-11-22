import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:praxis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:praxis/features/authentication/presentation/screens/login_screen.dart';
import 'package:praxis/features/authentication/presentation/screens/signup_screen.dart';
import 'package:praxis/features/home/presentation/screens/audio_screen.dart';
import 'package:praxis/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter(BuildContext context)
    : router = GoRouter(
        initialLocation: '/home',
        refreshListenable: GoRouterRefreshStream(
          context.read<AuthBloc>().stream,
        ),
        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;
          final isAuth = authState.status == AuthStatus.authenticated;
          final loggingIn = state.matchedLocation == LoginScreen.routeName;
          final signingUp = state.matchedLocation == SignupScreen.routeName;

          if (!isAuth &&
              (state.matchedLocation == '/home' ||
                  state.matchedLocation == '/audio')) {
            return LoginScreen.routeName;
          }
          if (isAuth && (loggingIn || signingUp)) {
            return '/home';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: SignupScreen.routeName,
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/audio',
            builder: (context, state) => const AudioScreen(),
          ),
        ],
      );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListener = () => notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (event) => notifyListener(),
    );
  }
  late final VoidCallback notifyListener;
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
