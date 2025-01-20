import 'dart:async';
import 'package:flutter/material.dart';

class ScheduleData {
  bool active;
  String period;
  int day;
  double percentage;
  String lunch;
  String periodicTimer;
  String timeOfDay = "beforeSchool";
  String message = "School has not started yet";

  ScheduleData({
    this.active = true,
    this.period = 'start',
    this.day = 1,
    this.percentage = .11,
    this.lunch = 'a',
    this.periodicTimer = '00:00:00',
  });
}

class Schedule {
  ScheduleData schedule = ScheduleData();

  final Function callbackAction;

  late Map<int, Map<String, String>> periodMap = {
    _secondsFromTime([0, 0, 0]): {
      'period': 'end',
      'message': 'School is out',
    },
    _secondsFromTime([8, 00, 0]): {
      'period': 'start',
      'message': 'School Starts in',
    },
    _secondsFromTime([8, 30, 0]): {
      'period': '1',
      'message': 'First Period ends in',
    },
    _secondsFromTime([9, 57, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([10, 05, 0]): {
      'period': '2',
      'message': 'Second Period ends in',
    },
    _secondsFromTime([11, 28, 0]): {
      'period': 'lunch',
    },
    _secondsFromTime([13, 29, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([13, 37, 0]): {
      'period': '4',
      'message': 'School ends in',
    },
    _secondsFromTime([15, 00, 0]): {
      'period': 'end',
      'message': 'School is out',
    },
    _secondsFromTime([24, 01, 0]): {
      'period': 'end',
      'message': 'School is out',
    },
  };

  late Map<int, Map<String, String>> aLunch = {
    _secondsFromTime([11, 28, 0]): {
      'period': 'aLunch',
      'message': 'A Lunch ends in',
    },
    _secondsFromTime([11, 58, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([12, 06, 0]): {
      'period': '3',
      'message': 'Third Period ends in',
    },
  };

  late Map<int, Map<String, String>> bLunch = {
    _secondsFromTime([11, 28, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([11, 36, 0]): {
      'period': '3',
      'message': 'B Lunch starts in',
    },
    _secondsFromTime([11, 58, 0]): {
      'period': 'bLunch',
      'message': 'B Lunch ends in',
    },
    _secondsFromTime([12, 28, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([12, 33, 0]): {
      'period': '3',
      'message': 'Third Period ends in',
    },
  };

  late Map<int, Map<String, String>> cLunch = {
    _secondsFromTime([11, 28, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([11, 36, 0]): {
      'period': '3',
      'message': 'C Lunch starts in',
    },
    _secondsFromTime([12, 28, 0]): {
      'period': 'cLunch',
      'message': 'C Lunch ends in',
    },
    _secondsFromTime([12, 58, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([13, 03, 0]): {
      'period': '3',
      'message': 'Third Period ends in',
    },
  };

  late Map<int, Map<String, String>> dLunch = {
    _secondsFromTime([11, 28, 0]): {
      'period': 'passing',
      'message': 'Passing Period ends in',
    },
    _secondsFromTime([11, 36, 0]): {
      'period': '3',
      'message': 'D Lunch starts in',
    },
    _secondsFromTime([12, 59, 0]): {
      'period': 'dLunch',
      'message': 'D Lunch ends in',
    },
  };

  Schedule({required this.callbackAction}) {
    startPeriodicTimer();
  }

  void dispose() {
    stopPeriodicTimer();
  }

  late int test = _secondsFromTime([11, 20, 0]);
  void startPeriodicTimer() {
    //every .50 seconds call this function
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (test == _secondsFromTime([24, 00, 0])) {
        test = _secondsFromTime([8, 00, 0]);
      }
      test = test + 1;
      if (schedule.active == false) {
        return timer.cancel();
      }
      DateTime now = DateTime.now();
      List<int> time = [now.hour, now.minute, now.second];
      int seconds = _secondsFromTime(time);
     // int seconds = test;
      //from list find where seconds is greater than or equal to a key value while being less than the next key value if it exists
      //second element should be the next key value if it exists

      int key = periodMap.keys.firstWhere(
        (key) {
          if (periodMap.keys.last == key) {
            return seconds >= key;
          }
          return seconds >= key &&
              seconds <
                  periodMap.keys
                      .elementAt(periodMap.keys.toList().indexOf(key) + 1);
        },
      );
      //make sure there is a
      int nextKey =
          periodMap.keys.elementAt(periodMap.keys.toList().indexOf(key) + 1);
      Map<String, String>? period = periodMap[key]!;

      if (period['period'] != 'end') {
        if (period['period'] == 'lunch') {
          Map<String, Map<int, Map<String, String>>> lunchMap = {
            'a': aLunch,
            'b': bLunch,
            'c': cLunch,
            'd': dLunch,
          };
          Map<int, Map<String, String>> lunch = lunchMap[schedule.lunch]!;
          key = lunch.keys.firstWhere(
            (key) {
              if (lunch.keys.last == key) {
                return seconds >= key;
              }
              return seconds >= key &&
                  seconds <
                      lunch.keys
                          .elementAt(lunch.keys.toList().indexOf(key) + 1);
            },
          );

          //if no next key then set next key to 13, 37, 00
          try {
            nextKey = lunch.keys.elementAt(lunch.keys.toList().indexOf(key) + 1);
          } catch (e) {
            nextKey = _secondsFromTime([13, 37, 0]);
          }
          setScheduleData(
            period: schedule.day == 1 ? '3' : '3',
            message: lunch[key]!['message']!,
            percentage: ((seconds - key) / (nextKey - key)) * 100,
            periodicTimer: _secondsToTime(nextKey - seconds),
          );
        } else {
          setScheduleData(
            period: period['period']!,
            message: period['message']!,
            percentage: ((seconds - key) / (nextKey - key)) * 100,
            periodicTimer: _secondsToTime(nextKey - seconds),
          );
        }
      }

      debugPrint('period: ${period['period']}');
      debugPrint('$seconds, $key');
    });
  }

  void setScheduleData(
      {required String period,
      required String message,
      required double percentage,
      required String periodicTimer}) {
    schedule.period = period;
    schedule.message = message;
    schedule.percentage = percentage;
    schedule.periodicTimer = periodicTimer;

    callbackAction();
  }

  void stopPeriodicTimer() {
    schedule.active = false;
  }

  String _secondsToTime(int seconds) {
    String hours = (seconds / 3600).floor().toString();
    String minutes = ((seconds % 3600) / 60).floor().toString();
    String second = (seconds % 60).floor().toString();

    if (hours.length == 1) {
      hours = '0$hours';
    }
    if (minutes.length == 1) {
      minutes = '0$minutes';
    }
    if (second.length == 1) {
      second = '0$second';
    }
    if (hours == '00' && minutes == '00') {
      return second;
    }
    if (hours == '00') {
      return '$minutes:$second';
    }

    return '$hours:$minutes:$second';
  }

  int _secondsFromTime(List<int> time) {
    return time[0] * 3600 + time[1] * 60 + time[2];
  }
}
