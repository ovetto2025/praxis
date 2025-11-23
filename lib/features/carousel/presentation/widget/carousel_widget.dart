import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final Function(int) onItemChanged;
  const CarouselWidget({super.key, required this.onItemChanged});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.75,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.4,
        onPageChanged: (index, reason) {
          onItemChanged(index);
        },
      ),
      items:
          [
            "assets/images/Carousel_images/Percorso_Culturale.png",
            "assets/images/Carousel_images/Percorso_Sport.png",
            "assets/images/Carousel_images/Percorso_Famiglia.png",
            "assets/images/Carousel_images/Percorso_Completo.jpg",
          ].map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset(item, fit: BoxFit.contain),
                );
              },
            );
          }).toList(),
    );
  }
}
