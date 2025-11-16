import 'package:flutter/material.dart';
import 'package:praxis/features/onboarding/presentation/widgets/oboarding_page_indicators.dart';
import 'circular_arrow_button_widget.dart';

class ContentContainerWidget extends StatelessWidget {
  final String title;
  final String description;

  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  /// 🔥 NUOVA CALLBACK
  final VoidCallback onSkip;

  const ContentContainerWidget({
    super.key,
    required this.title,
    required this.description,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final minHeight = screenHeight * 0.42;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: screenHeight,
          ),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              border: Border(
                top: BorderSide(
                  color: colors.primary,
                  width: 2,
                ),
              ),
            ),

            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---------- TITOLO ----------
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge?.copyWith(
                      color: colors.primary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------- DESCRIZIONE ----------
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),

                  const Spacer(),

                  // ---------- FOOTER ----------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 🔥 AGGIORNATO
                      GestureDetector(
                        onTap: onSkip,
                        child: const Text("Salta"),
                      ),

                      OnboardingPageIndicators(
                        currentIndex: currentIndex,
                        totalPages: totalPages,
                      ),

                      CircularArrowButton(
                        onPressed: onNext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
