import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:praxis/core/theme/app_theme.dart';
import 'package:praxis/features/authentication/data/auth_repository.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import 'package:praxis/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ INIT FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ⭐ LEGGIAMO SE L’ONBOARDING È GIÀ STATO VISTO
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  // ⭐ PASSIAMO IL VALORE ALL'APP
  runApp(Praxis(hasSeenOnboarding: hasSeenOnboarding));
}

class Praxis extends StatelessWidget {
  final bool hasSeenOnboarding;

  const Praxis({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
            child: Builder(
              builder: (context) {
                final appRouter = AppRouter(context, hasSeenOnboarding).router;

                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  routerConfig: appRouter,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
