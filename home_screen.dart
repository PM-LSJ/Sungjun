import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<int> timerDurations = [900, 1200, 1500, 1800, 2100];
  int selectedDuration = 1500;
  int totalSeconds = 1500;
  bool isRunning = false;
  int totalGoal = 0;
  int totalRound = 0;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalGoal++;
        isRunning = false;
      });

      if (totalGoal % 4 == 0) {
        setState(() {
          totalRound++;
          totalSeconds = 300; // 5 minutes rest period
          isRunning = true; // Automatically start the rest period
        });
      } else {
        setState(() {
          totalSeconds = selectedDuration;
        });
        timer.cancel(); // Stop the timer after completing a round
      }
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(milliseconds: 3),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    if (totalSeconds == selectedDuration) {
      "Nothing Happened!";
    } else {
      timer.cancel();
      setState(() {
        isRunning = false;
        totalSeconds = selectedDuration;
      });
    }
  }

  void onDurationSelected(int duration) {
    setState(() {
      selectedDuration = duration;
      totalSeconds = duration;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: IconButton(
                  iconSize: 120,
                  color: Theme.of(context).cardColor,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: Icon(
                    isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      onResetPressed();
                    },
                    child: Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'RESET',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListWheelScrollView(
                      itemExtent: 50,
                      //scrollDirection: Axis.horizontal,
                      children: timerDurations.map((duration) {
                        return GestureDetector(
                          onTap: () => onDurationSelected(duration),
                          child: Container(
                            width: 80,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: selectedDuration == duration
                                  ? Theme.of(context).cardColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              (duration ~/ 60).toString(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ROUND',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color)),
                                Text(
                                  '$totalRound',
                                  style: TextStyle(
                                      fontSize: 58,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('GOAL',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color)),
                                Text(
                                  '$totalGoal',
                                  style: TextStyle(
                                      fontSize: 58,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
