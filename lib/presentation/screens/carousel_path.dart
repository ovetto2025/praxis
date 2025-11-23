import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselPath extends StatefulWidget {
  static const String routeName = "/carousel";
  const CarouselPath({super.key});

  @override
  State<CarouselPath> createState() => CarouselPathState();
}

class CarouselPathState extends State<CarouselPath> {
  int selectedContent = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scegli il tuo percorso")),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1.75,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: 0.4,
            ),
            items:
                [
                  "lib/core/assets/images/Percorso Culturalle.png",
                  "lib/core/assets/images/Percorso Famiglia.png",
                  "lib/core/assets/images/Percorso Sport.png",
                  "lib/core/assets/images/Percorso Completo.jpg",
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    setState(() {
                      selectedContent = 0;
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: selectedContent == 0
                        ? Colors.red
                        : Colors.white,
                  ),
                  child: const Text("Dettagli percorso"),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      selectedContent = 1;
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: selectedContent == 1
                        ? Colors.red
                        : Colors.white,
                  ),
                  child: const Text("Elenco luoghi"),
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedContent == 0
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Text('ciao, bella ciao'),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('ciao, brutta ciao')],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
