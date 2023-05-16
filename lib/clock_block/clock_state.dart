part of 'clock_bloc.dart';

@immutable
class ClockState extends Equatable {
  final WorkPeriod workPeriod;
  final bool paused;

  const ClockState(
    this.workPeriod, {
    this.paused = false,
  });

  factory ClockState.initial() {
    return const ClockState(
      WorkPeriod.zero(),
    );
  }

  ClockState operator +(DateTime step) {
    return ClockState(
      workPeriod + step,
    );
  }

  ClockState pause() {
    return ClockState(
      workPeriod + DateTime.now(),
      paused: true,
    );
  }

  ClockState resume() {
    return ClockState(
      workPeriod + DateTime.now(),
      paused: false,
    );
  }

  bool get isRunning => workPeriod.isRunning;

  bool get isStopped => !isRunning;

  DateTime get startTime => workPeriod.startTime;
  Duration get elapsedTime => workPeriod.elapsedTime;

  @override
  List<Object?> get props => [workPeriod];
}
