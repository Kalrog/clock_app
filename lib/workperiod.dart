import 'package:equatable/equatable.dart';

class WorkPeriod extends Equatable {
  final List<DateTime> steps;
  const WorkPeriod(this.steps);

  const WorkPeriod.zero() : steps = const [];

  WorkPeriod operator +(DateTime step) {
    return WorkPeriod([...steps, step]);
  }

  bool get isRunning => steps.length % 2 == 1;

  bool get isStopped => steps.length % 2 == 0;

  DateTime get startTime => steps.first;
  DateTime get endTime => steps.last;
  Duration get elapsedTime {
    //For every pair of steps, add the difference between the two steps to the total
    // if one step is missing, use the current time
    Duration total = Duration.zero;
    if (steps.isEmpty) {
      return total;
    }
    for (int i = 0; i + 1 < steps.length; i += 2) {
      total += steps[i + 1].difference(steps[i]);
    }
    if (isRunning) {
      total += DateTime.now().difference(steps.last);
    }
    return total;
  }

  Duration get breakTime {
    Duration total = Duration.zero;
    if (steps.isEmpty) {
      return total;
    }
    for (int i = 1; i + 1 < steps.length; i += 2) {
      total += steps[i + 1].difference(steps[i]);
    }
    return total;
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((step) => step.toIso8601String()).toList(),
    };
  }

  factory WorkPeriod.fromJson(Map<String, dynamic> json) {
    return WorkPeriod(
      (json['steps'] as List<dynamic>)
          .map((step) => DateTime.parse(step as String))
          .toList(),
    );
  }

  @override
  List<Object> get props => [steps];
}
