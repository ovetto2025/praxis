import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ui/ui_bloc.dart';
import '../bloc/ui/ui_event.dart';

class PlaceSheet extends StatelessWidget {
  const PlaceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <= 0.16) {
          context.read<UiBloc>().add(HideSheets());
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.15,
        maxChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              color: Color(0xFFF6F4FB),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Luoghi Vicini",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // TODO: Inserire testi / asset reali
                placeCard(),
                placeCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget placeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Piazza di Città",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Distanza: 177 m - 253 passi",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [imageBox(), imageBox(), imageBox()],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {},
                child: const Text("Indicazioni"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {},
                child: const Text("Info"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget imageBox() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 140,
      height: 120,
      color: Colors.grey.shade300,
    );
  }
}
