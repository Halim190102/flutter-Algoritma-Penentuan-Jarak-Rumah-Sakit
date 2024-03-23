// map_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState(false, false)) {
    on<ToggleButtonEvent>((event, emit) {
      final newState = MapState(!state.but, state.mapT);
      emit(newState);
    });
    on<ToggleMapTypeEvent>((event, emit) {
      final newState = MapState(state.but, !state.mapT);
      emit(newState);
    });
  }
}
