import 'package:flutter/material.dart';
import 'package:praxis/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/authentication/presentation/screens/registration_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Praxis());
}

class Praxis extends StatelessWidget {
  const Praxis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praxis',
      theme: AppTheme.lightTheme,
      home: RegisterScreen(),
    );
  }
}
