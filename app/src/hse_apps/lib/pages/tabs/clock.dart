import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_apps/main.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/widgets/ClipShadowPath.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:hse_apps/functions/Schedule.dart';

class ClockTab extends StatefulWidget {
  const ClockTab({super.key});

  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<ClockTab> {
  late Schedule scheduleController;
  // 0 - 100 every 1 second increment by 1

  _changeLunch(String lunch) {
    setState(() {
      scheduleController.schedule.lunch = lunch;
    });
  }

  @override
  void initState() {
    super.initState();
    scheduleController = Schedule(callbackAction: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    scheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        scheduleController.schedule.message,
                        style: TextStyle(
                          color: brightness == Brightness.dark
                              ? secondary_text_color_dark
                              : secondary_text_color,
                          fontSize: 12,
                          fontFamily: "customRoboto",
                        ),
                      ),
                      Text(
                        scheduleController.schedule.periodicTimer,
                        style: TextStyle(
                          color: brightness == Brightness.dark
                              ? primary_text_color_dark
                              : primary_text_color,
                          fontSize: 40,
                          fontFamily: "customRoboto",
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
                CircleOfCircles(
                  numCircles: 0,
                  circleColor: main_color.withOpacity(0.3),
                  smallCircleRadius: 15,
                  bigCircleRadius: MediaQuery.of(context).size.width / 2.3,
                  
                ),
                CircularPercentIndicator(
                  radius: MediaQuery.of(context).size.width / 2.3,
                  lineWidth: 30,
                  backgroundColor:  main_color.withOpacity(.1),
                  percent: scheduleController.schedule.percentage / 100,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: main_color,
                  animateFromLastPercent: true,
                  animation: true,
                  
                )
              ]),
            ),
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                width: double.infinity,
        
                decoration: BoxDecoration(
                  color: brightness == Brightness.dark
                      ? main_container_color_dark
                      : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                                color: Brightness.dark == brightness
                                    ? Colors.grey.withOpacity(0.05)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                              ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Period:",
                              style: TextStyle(
                                  color: brightness == Brightness.dark
                                      ? primary_text_color_dark
                                      : primary_text_color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          _getPeriods(scheduleController.schedule.day,
                              scheduleController.schedule.period, brightness),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lunch:",
                              style: TextStyle(
                                  color: brightness == Brightness.dark
                                      ? primary_text_color_dark
                                      : primary_text_color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          _getLunches(scheduleController.schedule.lunch,
                              brightness, _changeLunch),
                        ])
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget _getPeriods(int day, String currentPeriod, Brightness brightness) {
  final List<String> periodsForDayOne = ["1", "2", "3", "4"];
  final List<String> periodsForDayTwo = ["5", "6", "7", "P"];
  List<String> periodsUsedInCode = [];

  if (day == 1) {
    periodsUsedInCode = periodsForDayOne;
  } else {
    periodsUsedInCode = periodsForDayTwo;
  }

  Widget create_period_circle(String period, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isCurrent
            ? brightness == Brightness.dark
                ? Colors.white
                :  main_color
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? Colors.transparent
              : brightness == Brightness.dark
                  ? secondary_Border_color_dark
                  : secondary_Border_color,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          period,
          style: TextStyle(
            color: isCurrent
                ? brightness == Brightness.dark
                    ? main_color
                    : Colors.white
                : brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: periodsUsedInCode
              .getRange(0, 2)
              .map((period) =>
                  create_period_circle(period, period == currentPeriod))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: periodsUsedInCode
              .getRange(2, 4)
              .map((period) =>
                  create_period_circle(period, period == currentPeriod))
              .toList(),
        )
      ],
    ),
  );
}

Widget _getLunches(
    String pickedLunch, Brightness brightness, Function changeLunch) {
  final List<String> lunchesUsedInCode = ["a", "b", "c", "d"];

  Widget create_lunch_circle(String period, bool isCurrent) {
    return GestureDetector(
      onTap: () {
        changeLunch(period);
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(top: 10, right: 10),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isCurrent
              ? brightness == Brightness.dark
                  ? Colors.white
                  : main_color
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCurrent
                ? Colors.transparent
                : brightness == Brightness.dark
                    ? secondary_Border_color_dark
                    : secondary_Border_color,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            period,
            style: TextStyle(
              color: isCurrent
                  ? brightness == Brightness.dark
                      ? main_color
                      : Colors.white
                  : brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              decoration: isCurrent ? TextDecoration.underline : null,

              decorationThickness: 4,
              decorationColor: isCurrent
                  ? brightness == Brightness.dark
                      ? main_color
                      : Colors.white
                  : brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: lunchesUsedInCode
              .getRange(0, 2)
              .map((period) =>
                  create_lunch_circle(period, period == pickedLunch))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: lunchesUsedInCode
              .getRange(2, 4)
              .map((period) =>
                  create_lunch_circle(period, period == pickedLunch))
              .toList(),
        )
      ],
    ),
  );
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    double curveHeight = 25;
    Path path = Path()
      ..moveTo(0, curveHeight)
      ..quadraticBezierTo(w / 2, -curveHeight, w, curveHeight)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CircleOfCircles extends StatelessWidget {
  final int numCircles;
  final Color circleColor;
  final double smallCircleRadius;
  final double bigCircleRadius;

  const CircleOfCircles({
    super.key,
    required this.numCircles,
    required this.circleColor,
    required this.smallCircleRadius,
    required this.bigCircleRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2 * bigCircleRadius,
      height: 2 * bigCircleRadius,
      child: Stack(
        children: List.generate(
          numCircles,
          (index) {
            double angle = (2 * pi * index) / numCircles;
            double x = bigCircleRadius +
                (bigCircleRadius - smallCircleRadius) * cos(angle);
            double y = bigCircleRadius +
                (bigCircleRadius - smallCircleRadius) * sin(angle);
            return Positioned(
              left: x - smallCircleRadius,
              top: y - smallCircleRadius,
              child: Container(
                width: 2 * smallCircleRadius,
                height: 2 * smallCircleRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
