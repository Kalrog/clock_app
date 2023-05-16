part of 'clock_bloc.dart';

@immutable
abstract class ClockEvent {}

class ClockStart extends ClockEvent {}

class ClockPause extends ClockEvent {}

class ClockResume extends ClockEvent {}

class ClockStop extends ClockEvent {}

class ClockReset extends ClockEvent {}
