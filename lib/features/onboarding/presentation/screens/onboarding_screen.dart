import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:praxis/data/onboarding_pages_data.dart';
import 'package:praxis/features/onboarding/presentation/widgets/content_container_widget.dart';
import 'package:praxis/features/authentication/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (!mounted) return; // ← 🔥 evita il crash async
    context.go(LoginScreen.routeName);
  }

  void _goNextPage() {
    final bool isLast = _currentIndex == onboardingPages.length - 1;

    if (!isLast) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _goPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingPages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Image.asset(
                  onboardingPages[index].imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                _goPreviousPage();
              } else if (details.primaryVelocity != null &&
                  details.primaryVelocity! < 0) {
                _goNextPage();
              }
            },
            child: SizedBox(
              height: 350,
              child: ContentContainerWidget(
                title: onboardingPages[_currentIndex].title,
                description: onboardingPages[_currentIndex].description,
                currentIndex: _currentIndex,
                totalPages: onboardingPages.length,
                onNext: _goNextPage,
                onSkip: _skipOnboarding,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
