import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ONBOARDING
import 'package:praxis/features/onboarding/presentation/screens/onboarding_screen.dart';

// AUTH
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_state.dart';
import 'package:praxis/features/authentication/presentation/screens/home_screen.dart';
import 'package:praxis/features/authentication/presentation/screens/login_screen.dart';
import 'package:praxis/features/authentication/presentation/screens/signup_screen.dart';

// PLACES
import 'package:praxis/features/places/presentation/screens/place_detail_screen.dart';

// HOME
import 'package:praxis/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:praxis/features/home/presentation/bloc/map/map_event.dart';
import 'package:praxis/features/home/presentation/screens/explore_screen.dart';

// AUDIO
import 'package:praxis/features/audio/presentation/screens/audio_screen.dart';

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

          final loggingIn = state.matchedLocation == LoginScreen.routeName;
          final signingUp = state.matchedLocation == SignupScreen.routeName;

          if (!isAuth && (state.matchedLocation == HomeScreen.routeName)) {
            return LoginScreen.routeName;
          }

          if (isAuth && (loggingIn || signingUp)) {
            return HomeScreen.routeName;
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
            path: HomeScreen.routeName,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: ExploreScreen.routeName,
            builder: (context, state) {
              final placeId = state.uri.queryParameters['placeId'];
              if (placeId != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    context.read<MapBloc>().add(FocusOnPlace(placeId));
                  }
                });
              }
              return const ExploreScreen();
            },
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
    notifyListener = () => notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListener());
  }

  late final VoidCallback notifyListener;
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
