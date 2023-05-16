part of 'history_bloc.dart';

class HistoryState extends Equatable {
  final List<WorkPeriod> workPeriods;
  const HistoryState(
    this.workPeriods,
  );

  factory HistoryState.initial() {
    return const HistoryState(
      [],
    );
  }

  HistoryState operator +(WorkPeriod workPeriod) {
    return HistoryState(
      [workPeriod, ...workPeriods],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workPeriods':
          workPeriods.map((workPeriod) => workPeriod.toJson()).toList(),
    };
  }

  factory HistoryState.fromJson(Map<String, dynamic> json) {
    return HistoryState(
      (json['workPeriods'] as List<dynamic>)
          .map((workPeriod) => WorkPeriod.fromJson(workPeriod))
          .toList(),
    );
  }

  @override
  List<Object> get props => [workPeriods];
}
