import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:praxis/features/places/data/places_mock.dart';
import 'package:praxis/features/places/models/place_model.dart';

import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import '../bloc/map/map_state.dart';

class MapScreenWidget extends StatefulWidget {
  const MapScreenWidget({super.key});

  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget> {
  GoogleMapController? _controller;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<PlaceModel> _filtered = [];
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(LoadMarkers());
    _searchController.addListener(_onSearchChanged);
    _searchFocus.addListener(() {
      if (!_searchFocus.hasFocus) {
        setState(() => _showResults = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filtered = [];
        _showResults = false;
      });
      return;
    }
    setState(() {
      _filtered = placesMock
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
      _showResults = _filtered.isNotEmpty;
    });
  }

  void _selectPlace(PlaceModel place) {
    _searchController.text = place.title;
    setState(() {
      _showResults = false;
    });
    context.read<MapBloc>().add(FocusOnPlace(place.id));
  }

  void _maybeMoveCamera(MapState state) {
    if (_controller != null && state.cameraTarget != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: state.cameraTarget!, zoom: 16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, mapState) => _maybeMoveCamera(mapState),
      builder: (context, mapState) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_showResults) setState(() => _showResults = false);
            _searchFocus.unfocus();
          },
          child: Stack(
            children: [
              /// 🌍 MAPPA
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(45.4665, 7.8756),
                  zoom: 14,
                ),
                markers: mapState.markers,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _controller = controller,
              ),

              /// 🔎 SEARCH BAR
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: SafeArea(
                  child: Column(
                    children: [
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(14),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: InputDecoration(
                            hintText: 'Cerca luogo... ',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _filtered = [];
                                        _showResults = false;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) {
                            if (_filtered.length == 1) {
                              _selectPlace(_filtered.first);
                            }
                          },
                        ),
                      ),
                      if (_showResults)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final place = _filtered[index];
                              return ListTile(
                                title: Text(place.title),
                                subtitle: Text(
                                  '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                leading: Icon(
                                  Icons.place,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onTap: () => _selectPlace(place),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
