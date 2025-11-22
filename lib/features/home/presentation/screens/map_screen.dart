import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/ui/ui_bloc.dart';
import '../bloc/ui/ui_event.dart';
import '../bloc/ui/ui_state.dart';

import '../widgets/map_screen_widget.dart';
import '../widgets/place_sheet.dart';
import '../widgets/route_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌍 MAPPA E CONTROLLI BASE
          const MapScreenWidget(),

          /// 🔘 Pulsanti Percorsi / Luoghi
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 77, left: 16, right: 16),
              child: BlocBuilder<UiBloc, UiState>(
                builder: (context, uiState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: uiState.showRoutes
                              ? Colors.green
                              : Colors.white,
                          side: const BorderSide(color: Colors.green),
                        ),
                        onPressed: () {
                          context.read<UiBloc>().add(ShowRoutesSheet());
                        },
                        child: Text(
                          "Percorsi",
                          style: TextStyle(
                            color: uiState.showRoutes
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: uiState.showPlaces
                              ? Colors.green
                              : Colors.white,
                          side: const BorderSide(color: Colors.green),
                        ),
                        onPressed: () {
                          context.read<UiBloc>().add(ShowPlacesSheet());
                        },
                        child: Text(
                          "Elenco luoghi",
                          style: TextStyle(
                            color: uiState.showPlaces
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: "audioBtn",
                        mini: true,
                        onPressed: () => context.push('/audio'),
                        child: const Icon(Icons.play_arrow),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 220,
            child: Column(
              children: [
                // 🔘 Faccina
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.emoji_emotions, size: 32),
                ),
                const SizedBox(height: 15),
                // 🔘 Volume
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.volume_up, size: 32),
                ),
              ],
            ),
          ),

          /// 📄 BOTTOM SHEETS
          BlocBuilder<UiBloc, UiState>(
            builder: (context, uiState) {
              if (uiState.showPlaces) return const PlaceSheet();
              if (uiState.showRoutes) return const RouteSheet();
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
