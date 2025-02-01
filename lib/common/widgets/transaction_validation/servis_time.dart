import 'dart:async';

import 'package:flutter/material.dart';

class ServisTime extends StatefulWidget {
  const ServisTime({super.key});



  @override
  _ServisTimeState createState() => _ServisTimeState();
}


class _ServisTimeState extends State<ServisTime> {
// Define the duration of the countdown timer
  Duration _duration = const Duration(minutes: 2);
// Define a Timer object
  Timer? _timer;
// Define a variable to store the current countdown value
  int _countdownValue = 1;
  int _countdownValue1 = 10;

  @override
  void initState() {
    super.initState();
// Start the countdown timer
    startTimer();
  }

  @override
  void dispose() {
// Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

// Method to start the countdown timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1,seconds: 10), (timer) {
      if (_duration.inMinutes <= 0) {
// Countdown is finished
        _timer?.cancel();
// Perform any desired action when the countdown is completed
      } else {
// Update the countdown value and decrement by 1 second
        setState(() {
          _countdownValue1 = _duration.inMinutes;
          _countdownValue = _duration.inSeconds;
          _duration = _duration - const Duration(minutes: 2,seconds: 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_countdownValue1:$_countdownValue', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center);
  }
}