import 'package:clock_app/workperiod.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends HydratedBloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryState.initial()) {
    on<HistoryAdd>((event, emit) {
      emit(state + event.workPeriod);
    });
    on<HistoryClear>((event, emit) {
      emit(HistoryState.initial());
    });
  }

  @override
  HistoryState? fromJson(Map<String, dynamic> json) =>
      HistoryState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(HistoryState state) => state.toJson();
}
