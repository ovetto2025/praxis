import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/core/fonts/app_typography.dart';
import 'package:praxis/core/theme/app_theme.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_event.dart';
import 'package:praxis/features/carousel/data/carousel_data.dart';
import 'package:praxis/features/carousel/models/carousel_model.dart';
import 'package:praxis/features/carousel/presentation/widget/carousel_description.dart';
import 'package:praxis/features/carousel/presentation/widget/carousel_location.dart';
import 'package:praxis/features/carousel/presentation/widget/carousel_widget.dart';
import 'package:praxis/shared/widgets/main_red_button.dart';

class CarouselPath extends StatefulWidget {
  static const String routeName = "/carousel";

  const CarouselPath({super.key});

  @override
  State<CarouselPath> createState() => CarouselPathState();
}

class CarouselPathState extends State<CarouselPath> {
  List<bool> isSelected = [true, false];
  int currentCarouselIndex = 0; //Index of the carosel

  @override
  Widget build(BuildContext context) {
    final CarouselModel items = carouselData.firstWhere(
      (p) => p.numberId == currentCarouselIndex,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CarouselWidget(
              onItemChanged: (index) {
                setState(() {
                  currentCarouselIndex = index;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ToggleButtons(
                borderWidth: 2,
                borderRadius: BorderRadius.circular(12),
                selectedColor: AppTheme.primaryColor,
                fillColor: AppTheme.primaryColor.withAlpha(128),
                color: AppTheme.primaryColor,
                borderColor: AppTheme.primaryColor,
                selectedBorderColor: AppTheme.primaryColor,
                textStyle: AppTypography.bodyBold,
                onPressed: (index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Dettagli percorso"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Elenco luoghi"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isSelected[0]
                  ? CarouselDescription(text: items.description)
                  : CarouselLocation(location: items.location),
            ),
            MainRedButton(
              label: "Conferma",
              onPressed: () {
                context.read<AuthBloc>().add(AuthCarouselCompleted());
              },
            ),
          ],
        ),
      ),
    );
  }
}
