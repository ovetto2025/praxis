import 'package:flutter/material.dart';
import 'package:praxis/presentation/widgets/circular_arrow_button_widget.dart';
import 'package:praxis/presentation/widgets/content_container_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: CircularArrowButton(size: 56),

      ),
    );
  }
}
