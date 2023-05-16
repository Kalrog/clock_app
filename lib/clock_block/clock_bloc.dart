import 'package:bloc/bloc.dart';
import 'package:clock_app/workperiod.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc() : super(ClockState.initial()) {
    on<ClockStart>((event, emit) {
      emit(state + DateTime.now());
    });
    on<ClockPause>((event, emit) {
      emit(state.pause());
    });
    on<ClockResume>((event, emit) {
      emit(state.resume());
    });
    on<ClockStop>((event, emit) {
      emit(state + DateTime.now());
    });
    on<ClockReset>((event, emit) {
      emit(ClockState.initial());
    });
  }
}
