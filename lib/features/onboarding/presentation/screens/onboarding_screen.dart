import 'package:flutter/material.dart';

// IMPORT CORRETTO secondo la tua struttura
import 'package:praxis/data/onboarding_pages_data.dart';

import 'package:praxis/features/onboarding/presentation/widgets/content_container_widget.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Cambia indice in base allo swipe
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  // Freccia avanti
  void _goNextPage() {
    if (_currentIndex < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // TODO: navigazione finale → login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sfondo globale già impostato nel Theme
      body: Column(
        children: [
          // --------------------------------------------------------------
          //                        IMMAGINE DELLA PAGINA
          // --------------------------------------------------------------
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingPages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  color: Colors.grey.shade300, // placeholder
                  child: Image.asset(
                    onboardingPages[index].imagePath,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // --------------------------------------------------------------
          //                     CONTENITORE INFERIORE
          // --------------------------------------------------------------
          SizedBox(
            height: 350,
            child: ContentContainerWidget(
              title: onboardingPages[_currentIndex].title,
              description: onboardingPages[_currentIndex].description,

              // Parametri dinamici
              currentIndex: _currentIndex,
              totalPages: onboardingPages.length,
              onNext: _goNextPage,
            ),
          ),
        ],
      ),
    );
  }
}
