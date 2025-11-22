import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui_event.dart';
import 'ui_state.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  UiBloc() : super(UiState()) {
    on<ShowRoutesSheet>((event, emit) {
      emit(state.copyWith(showRoutes: true, showPlaces: false));
    });

    on<ShowPlacesSheet>((event, emit) {
      emit(state.copyWith(showPlaces: true, showRoutes: false));
    });

    on<HideSheets>((event, emit) {
      emit(UiState());
    });
  }
}
