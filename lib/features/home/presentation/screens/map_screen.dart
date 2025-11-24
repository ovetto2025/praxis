import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/features/audio/presentation/screens/audio_screen.dart';

import '../bloc/ui/ui_bloc.dart';
import '../bloc/ui/ui_event.dart';
import '../bloc/ui/ui_state.dart';
import '../bloc/map/map_bloc.dart';

import '../widgets/map_screen_widget.dart';
import '../widgets/place_sheet.dart';
import '../widgets/route_sheet.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = '/map';
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UiBloc()),
        BlocProvider(create: (_) => MapBloc()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            /// 🌍 MAPPA E CONTROLLI BASE
            const MapScreenWidget(),

            /// 🔘 Pulsanti Percorsi / Luoghi / Audio
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: BlocBuilder<UiBloc, UiState>(
                builder: (context, uiState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: uiState.showRoutes
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.white,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: uiState.showPlaces
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.white,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            GoRouter.of(context).push(AudioScreen.routeName);
                          },
                          child: Icon(
                            Icons.audiotrack,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            /// 📄 BOTTOM SHEETS
            BlocBuilder<UiBloc, UiState>(
              builder: (context, uiState) {
                if (!uiState.showPlaces && !uiState.showRoutes) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: uiState.showPlaces
                      ? const PlaceSheet()
                      : const RouteSheet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
