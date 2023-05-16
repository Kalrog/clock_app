import 'package:clock_app/clock_block/clock_bloc.dart';
import 'package:clock_app/history_bloc/history_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'clock_page.dart';
import 'history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHydratedStorage();
  runApp(const TimeClockApp());
}

Future<void> initializeHydratedStorage() async {
  //Open correctly on web
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
}

class TimeClockApp extends StatefulWidget {
  const TimeClockApp({super.key});

  @override
  State<TimeClockApp> createState() => _TimeClockAppState();
}

class _TimeClockAppState extends State<TimeClockApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ClockBloc _clockBloc = ClockBloc();
  final HistoryBloc _historyBloc = HistoryBloc();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _clockBloc,
          ),
          BlocProvider(
            create: (context) => _historyBloc,
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            title: 'Time Clock App',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              useMaterial3: true,
            ),
            home: Scaffold(
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                body: TabBarView(controller: _tabController, children: [
                  BlocListener<ClockBloc, ClockState>(
                    listener: (context, state) {
                      if (state.isStopped &&
                          !state.paused &&
                          state.elapsedTime > Duration.zero) {
                        context
                            .read<HistoryBloc>()
                            .add(HistoryAdd(state.workPeriod));
                      }
                    },
                    child: const ClockPage(),
                  ),
                  const HistoryPage(),
                ]),
                bottomNavigationBar: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Clock', icon: Icon(Icons.access_time)),
                      Tab(text: 'Reports', icon: Icon(Icons.bar_chart)),
                    ],
                  ),
                ),
                floatingActionButton: _tabController.index == 0
                    ? null
                    : FloatingActionButton(
                        onPressed: () {
                          context.read<HistoryBloc>().add(HistoryClear());
                        },
                        child: const Icon(Icons.delete),
                      )),
          );
        }));
  }
}
