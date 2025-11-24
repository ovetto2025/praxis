import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import '../../../authentication/logic/bloc/auth_event.dart';
import '../../data/onboarding_pages_data.dart';
import '../widgets/content_container_widget.dart';
import 'package:praxis/features/authentication/presentation/screens/login_screen.dart';
import 'package:praxis/features/carousel/presentation/screens/carousel_path.dart';

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
    // Aggiorna lo stato del bloc
    if (mounted) {
      context.read<AuthBloc>().add(AuthOnboardingCompleted());
    }
    final token = prefs.getString('token');
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.go(CarouselPath.routeName);
    } else {
      context.go(LoginScreen.routeName);
    }
  }

  void _goNextPage() {
    final isLast = _currentIndex == onboardingPages.length - 1;
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

  void _skipOnboarding() => _completeOnboarding();

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
                return SafeArea(
                  top: true,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      onboardingPages[index].imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! > 0) {
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
