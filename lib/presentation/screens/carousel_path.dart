import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselPath extends StatelessWidget {
  static const String routeName = '/carousel';
  const CarouselPath({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scegli il tuo percorso")),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
          ),
          items:
              [
                'lib/core/assets/images/Percorso Culturalle.png',
                'lib/core/assets/images/Percorso Famiglia.png',
                'lib/core/assets/images/Percorso Sport.png',
                null, // Placeholder for the fourth image
              ].map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: item != null
                          ? Image.asset(item, fit: BoxFit.cover)
                          : const Center(child: Text('Placeholder')),
                    );
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
