import 'package:animations/animations.dart';
import 'package:clock_app/history_bloc/history_bloc.dart';
import 'package:clock_app/workperiod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}

String formatDuration(Duration duration) {
  return '${duration.inHours.toString().padLeft(2, '0')}:'
      '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
      '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year.toString().padLeft(2, '0')}';
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state.workPeriods.isEmpty) {
          return Center(
            child: Text(
              'No history yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }
        return Scrollbar(
          child: ListView.separated(
              itemCount: state.workPeriods.length,
              separatorBuilder: (context, index) {
                //put devider between dates
                if (index + 1 < state.workPeriods.length) {
                  final current = state.workPeriods[index];
                  final next = state.workPeriods[index + 1];
                  if (current.startTime.day != next.startTime.day) {
                    return Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            formatDate(next.startTime),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  }
                }
                return SizedBox.shrink();
              },
              itemBuilder: (context, index) {
                return BlocSelector<HistoryBloc, HistoryState, WorkPeriod>(
                  selector: (state) {
                    return state.workPeriods[index];
                  },
                  builder: (context, workPeriod) {
                    return OpenContainer(
                      closedBuilder: (context, action) => Card(
                        child: ListTile(
                          title: Text(
                            formatDate(workPeriod.startTime),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            formatDuration(workPeriod.elapsedTime),
                          ),
                          onTap: () {
                            action();
                          },
                        ),
                      ),
                      openBuilder: (context, action) =>
                          DetailsPage(workPeriod: workPeriod),
                    );
                  },
                );
              }),
        );
      },
    );
  }
}

class DetailsPage extends StatelessWidget {
  final WorkPeriod workPeriod;
  const DetailsPage({
    super.key,
    required this.workPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          formatDate(workPeriod.startTime),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text(
                      'Worked',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      formatDuration(workPeriod.elapsedTime),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text(
                      'Breaks',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      formatDuration(workPeriod.breakTime),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: workPeriod.steps.length - 1,
                itemBuilder: (context, index) {
                  if (index % 2 == 0) {
                    return WorkStepTile(
                      start: workPeriod.steps[index],
                      end: workPeriod.steps[index + 1],
                    );
                  } else {
                    return BreakStepTile(
                      start: workPeriod.steps[index],
                      end: workPeriod.steps[index + 1],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkStepTile extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  const WorkStepTile({
    super.key,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Work ${formatTime(start)} - ${formatTime(end)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        formatDuration(end.difference(start)),
      ),
    );
  }
}

class BreakStepTile extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  const BreakStepTile({
    super.key,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Break ${formatTime(start)} - ${formatTime(end)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        formatDuration(end.difference(start)),
      ),
    );
  }
}
