import 'dart:async';
import 'dart:math';

import 'package:clock_app/clock_block/clock_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fading_circles_button.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
      child: LayoutBuilder(builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight / 2);
        return Stack(
          children: [
            const Center(
              child: ClockButton(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: constraints.maxHeight / 2 + size / 2 - 40,
              child: const TakeBreakButton(),
            ),
            const Align(alignment: Alignment(0, -0.7), child: TimeView())
          ],
        );
      }),
    );
  }
}

class ClockButton extends StatelessWidget {
  const ClockButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: BlocBuilder<ClockBloc, ClockState>(
        builder: (context, state) {
          return FadingCirclesButton(
            onPressed: () {
              ClockBloc clockBloc = context.read<ClockBloc>();
              if (clockBloc.state.isRunning) {
                clockBloc.add(ClockStop());
              } else if (clockBloc.state.paused) {
                clockBloc.add(ClockResume());
              } else {
                clockBloc.add(ClockReset());
                clockBloc.add(ClockStart());
              }
            },
            color:
                state.isRunning ? Colors.pinkAccent.shade200 : Colors.lightBlue,
            inset: state.isRunning ? 40 : 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocSelector<ClockBloc, ClockState, String>(
                  selector: (state) {
                    if (state.isRunning) {
                      return 'Stop';
                    } else if (state.paused) {
                      return 'Resume';
                    } else {
                      return 'Start';
                    }
                  },
                  builder: (context, text) {
                    return Text(
                      text,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                          ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TimeView extends StatefulWidget {
  const TimeView({
    super.key,
  });

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  Timer? updateTimer;

  void updateClock(Timer timer) {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateTimer =
        Timer.periodic(const Duration(milliseconds: 100), updateClock);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockBloc, ClockState>(
      builder: (context, state) {
        return Text(
          formatTime(state),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Colors.black,
              ),
        );
      },
    );
  }

  String formatTime(ClockState state) {
    String time = '';
    time += state.elapsedTime.inHours.toString().padLeft(2, '0');
    time += ':';
    time +=
        state.elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    time += ':';
    time +=
        state.elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0');

    return time;
  }
}

class TakeBreakButton extends StatelessWidget {
  const TakeBreakButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ClockBloc, ClockState, bool>(
      selector: (state) {
        return state.isRunning;
      },
      builder: (context, isRunning) {
        return IgnorePointer(
          ignoring: !isRunning,
          child: AnimatedOpacity(
            //start animation late when button is enabled
            curve: const Interval(0.2, 1, curve: Curves.easeInOutQuad),
            duration: const Duration(milliseconds: 500),
            opacity: isRunning ? 1 : 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.white,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      context.read<ClockBloc>().add(ClockPause());
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.timer,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Take Break',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
