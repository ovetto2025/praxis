import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:praxis/core/theme/app_theme.dart';
import 'package:praxis/data/repository/auth_repository.dart';
import 'package:praxis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:praxis/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ INIT FIREBASE (necessario per AuthRepository + BLoC)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Praxis());
}

class Praxis extends StatelessWidget {
  const Praxis({super.key});

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
                final appRouter = AppRouter(context).router;

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
