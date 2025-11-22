import 'package:flutter/material.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ascolto Percorso")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.mic, size: 130),
            const SizedBox(height: 20),
            const Text(
              "Audio del percorso selezionato...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Slider(value: 0.3, onChanged: (v) {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 70,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
