part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class HistoryAdd extends HistoryEvent {
  final WorkPeriod workPeriod;

  const HistoryAdd(this.workPeriod);

  @override
  List<Object> get props => [workPeriod];
}

class HistoryClear extends HistoryEvent {}
