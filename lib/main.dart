import 'package:flutter/material.dart';
import 'package:praxis/core/theme/app_theme.dart';

import 'features/presentation/screens/registration_page.dart';

void main() {
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
