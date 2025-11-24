import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ONBOARDING
import 'package:praxis/features/onboarding/presentation/screens/onboarding_screen.dart';

// AUTH
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_state.dart';
import 'package:praxis/features/authentication/presentation/screens/login_screen.dart';
import 'package:praxis/features/authentication/presentation/screens/signup_screen.dart';

// PLACES
import 'package:praxis/features/places/presentation/screens/place_detail_screen.dart';
import 'package:praxis/features/home/presentation/screens/map_screen.dart';

import '../../features/audio/presentation/screens/audio_screen.dart';
import '../../features/carousel/presentation/screens/carousel_path.dart';

class AppRouter {
  final GoRouter router;

  AppRouter(BuildContext context, bool hasSeenOnboarding)
    : router = GoRouter(
        initialLocation: hasSeenOnboarding
            ? LoginScreen.routeName
            : OnboardingScreen.routeName,

        refreshListenable: GoRouterRefreshStream(
          context.read<AuthBloc>().stream,
        ),

        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;
          final isAuth = authState.status == AuthStatus.authenticated;
          final hasSeenOnboarding = authState.hasSeenOnboarding;
          final isCarouselDone = authState.isCarouselDone;

          // Onboarding
          if (!hasSeenOnboarding &&
              state.matchedLocation != OnboardingScreen.routeName) {
            return OnboardingScreen.routeName;
          }

          // Authentication
          if (hasSeenOnboarding &&
              !isAuth &&
              state.matchedLocation != LoginScreen.routeName &&
              state.matchedLocation != SignupScreen.routeName) {
            return LoginScreen.routeName;
          }

          // Carousel
          if (hasSeenOnboarding &&
              isAuth &&
              !isCarouselDone &&
              state.matchedLocation != CarouselPath.routeName) {
            return CarouselPath.routeName;
          }

          // MapScreen
          if (hasSeenOnboarding &&
              isAuth &&
              isCarouselDone &&
              state.matchedLocation != MapScreen.routeName) {
            return MapScreen.routeName;
          }

          return null;
        },

        routes: [
          GoRoute(
            path: OnboardingScreen.routeName,
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: SignupScreen.routeName,
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: MapScreen.routeName,
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: CarouselPath.routeName,
            builder: (context, state) => const CarouselPath(),
          ),

          // 🆕 ROUTE DETTAGLIO LUOGO
          GoRoute(
            path: PlaceDetailScreen.routeName,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PlaceDetailScreen(placeId: id);
            },
          ),
          GoRoute(
            path: AudioScreen.routeName,
            builder: (context, state) => const AudioScreen(),
          ),
        ],
      );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
