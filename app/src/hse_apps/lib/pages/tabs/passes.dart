import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hse_apps/functions/Schedule.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/ws.dart';
import 'package:hse_apps/pages/tabs/modals/pending_pass.dart';
import 'package:hse_apps/theme/theme.dart';

class PassesTab extends StatefulWidget {
  const PassesTab({super.key});

  @override
  _PassesTabState createState() => _PassesTabState();
}

class _PassesTabState extends State<PassesTab> {
  // Mock Data for Pending Pass Requests
  late String currentPeriod;
  late String currentClassName;
  bool disposed = false;
  final incomingScrollController = ScrollController();
  final activeScrollController = ScrollController();
  // Mock Data for Active Passes
  ActivePass activePass = ActivePass('Math Class', '8:30 - 9:57', false);

  String _formatTime(TimeOfDay time) {
    // Converts TimeOfDay to a string with AM/PM format
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  void acceptRequest(int index, TimeOfDay time) {}

  void rejectRequest(int index) {}

  void updateCurrentPeriod() {
    var period = getCurrentPeriod();
    late String text;
    var newPeriodMap = {
      "end": 0,
      "start": 0,
      "passing": 90,
    };

    debugPrint("Current period: $period");

    if (period != activePass.destination) {
      // Check if the new period is in the map
      if (period.toLowerCase() == "passing") {
        // If the period is "passing", set the current period to "passing"
        text = "Passing Period";
      } else if (period.toLowerCase().contains("end")) {
        // If the period contains "end", set the current period to "end"
        text = "Schools Out";
      } else if (period.toLowerCase().contains("start")) {
        // If the period contains "start", set the current period to "start"
        text = "School Starts Soon";
      } else if (period.toLowerCase().contains("lunch")) {
        // If the period contains "lunch", set the current period to "lunch"
        text = "Lunch";
      } else {
        // If not, set the current period to "unknown"
        final classInfo = Auth.userData?['classInfo'];
        final periodInfo = classInfo != null ? classInfo[period] : null;
        text = periodInfo != null
            ? periodInfo["className"] ?? "Unknown"
            : "Unknown";
      }
      setState(() {
        activePass.destination = text;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //every 5 seconds check for the current period
    WebSocketProvider.setUpdateFunction(updateCurrentPeriod);
    updateCurrentPeriod();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      disposed ? timer.cancel() : updateCurrentPeriod();
    });
  }

  @override
  void dispose() {
    incomingScrollController.dispose();
    activeScrollController.dispose();
    disposed = true;
    super.dispose();
  }

  void _show_request_modal(
      BuildContext context, PassRequest request, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PendingPassRequestModal(
          passRequest: request,
          onAccept: () {
            Navigator.pop(context); // Close modal
            acceptRequest(index, TimeOfDay.now()); // Call accept logic
          },
          onReject: () {
            Navigator.pop(context); // Close modal
            rejectRequest(index); // Call reject logic
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var timeHour = TimeOfDay.now().hour;
    final brightness = Theme.of(context).brightness;
    String timeOfDay = timeHour < 12
        ? 'Morning'
        : timeHour < 17
            ? 'Afternoon'
            : 'Evening';
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              //min height to prevent overflow
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(minHeight: 120, maxHeight: 370),

              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    main_color,
                    main_color.withOpacity(.9),
                    main_color.withOpacity(.2),
                  ],
                  tileMode: TileMode.decal,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Brightness.dark == brightness
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Good $timeOfDay, ${Auth.userData?['firstName'] ?? 'first'} ${Auth.userData?['lastName'] ?? 'last'}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current Class',
                      style: TextStyle(fontSize: 14, color: opaque_white_text),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      decoration: BoxDecoration(
                        color: brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activePass.destination.length > 20
                                ? activePass.destination.substring(0, 22) +
                                    '...'
                                : activePass.destination,
                            style: TextStyle(
                              fontSize: 16,
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            activePass.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: brightness == Brightness.dark
                                  ? secondary_text_color_dark
                                  : secondary_text_color_dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    WebSocketProvider.currentPasses.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Passes',
                                style: TextStyle(
                                    fontSize: 14, color: opaque_white_text),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                //set max height the space left
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: RawScrollbar(
                                    thumbVisibility: true,
                                    thumbColor: brightness == Brightness.dark
                                        ? Colors.grey[700]
                                        : Colors.grey[400],
                                    radius: const Radius.circular(10),
                                    controller: activeScrollController,
                                    scrollbarOrientation:
                                        ScrollbarOrientation.right,
                                    child: SingleChildScrollView(
                                        controller: activeScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              for (var pass in WebSocketProvider
                                                  .currentPasses)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: brightness ==
                                                            Brightness.dark
                                                        ? Colors.grey[900]
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        pass["Destination"]
                                                                    .length >
                                                                20
                                                            ? pass["Destination"]
                                                                    .substring(
                                                                        0, 22) +
                                                                '...'
                                                            : pass[
                                                                "Destination"],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${DateTime.fromMillisecondsSinceEpoch(pass["PassTime"]).toLocal().hour}:${DateTime.fromMillisecondsSinceEpoch(pass["PassTime"]).toLocal().minute.toString().padLeft(2, '0')}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? secondary_text_color_dark
                                                              : secondary_text_color_dark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ))),
                              ),
                            ],
                          )
                        : Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'no active passes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Incoming Passes',
              style: TextStyle(
                fontSize: 16,
                color: brightness == Brightness.dark
                    ? Colors.white
                    : secondary_text_color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          WebSocketProvider.incomingPassRequests.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: RawScrollbar(
                      controller: incomingScrollController,
                      thumbColor: brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[400],
                      thumbVisibility: true,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: incomingScrollController,
                        physics: const ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: WebSocketProvider.incomingPassRequests
                              .map((request) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        ),
                                        child: ListTile(
                                          //if first item top pading is 0
                                          contentPadding: WebSocketProvider
                                                      .incomingPassRequests
                                                      .indexOf(request) ==
                                                  0
                                              ? const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10,
                                                )
                                              : const EdgeInsets.only(
                                                  bottom: 10,
                                                  right: 10,
                                                  left: 10,
                                                  top: 10),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                main_color.withOpacity(0.2),
                                            child: Icon(
                                              Icons.mail_rounded,
                                              color: main_color,
                                            ),
                                          ),
                                          trailing: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  main_color.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: TextButton(
                                                onPressed: () {
                                                  _show_request_modal(
                                                      context,
                                                      PassRequest(
                                                          classUUID: request[
                                                              "CurrentClassUUID"],
                                                          passUUID:
                                                              request["PassId"],
                                                          teacher: request[
                                                              "SenderName"],
                                                          passType: int.tryParse(
                                                                      request[
                                                                          "PassType"]) !=
                                                                  null
                                                              ? 'Assistance Request'
                                                              : request[
                                                                  "PassType"],
                                                          requestedAt:
                                                              "${DateTime.fromMillisecondsSinceEpoch(request["PassTime"]).toLocal().hour}:${DateTime.fromMillisecondsSinceEpoch(request["PassTime"]).toLocal().minute.toString().padLeft(2, '0')}",
                                                          expiresAt:
                                                              "${DateTime.fromMillisecondsSinceEpoch(request["PassTime"]).toLocal().add(const Duration(minutes: 15)).hour}:${DateTime.fromMillisecondsSinceEpoch(request["PassTime"]).toLocal().add(const Duration(minutes: 15)).minute.toString().padLeft(2, '0')}",
                                                          time: DateTime.now()
                                                              .toString(),
                                                          icon: Icons
                                                              .access_time),
                                                      WebSocketProvider
                                                          .incomingPassRequests
                                                          .indexOf(request));
                                                },
                                                child: const Text(
                                                  'Accept',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                          ),
                                          title: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    request["SenderName"] ?? '',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                Text(request["PassType"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: brightness ==
                                                              Brightness.dark
                                                          ? secondary_text_color_dark
                                                          : secondary_text_color,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      (WebSocketProvider.incomingPassRequests
                                                  .indexOf(request) ==
                                              WebSocketProvider
                                                      .incomingPassRequests
                                                      .length -
                                                  1)
                                          ? const SizedBox(height: 20)
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Divider(
                                                color: brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[900]
                                                    : Colors.grey[300],
                                                height: 1,
                                              ),
                                            ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'You have no pending requests',
                    style: TextStyle(
                      fontSize: 14,
                      color: brightness == Brightness.dark
                          ? secondary_text_color_dark
                          : secondary_text_color,
                    ),
                  ),
                ),
        ]),
      ),
    );
  }
}

// Data Classes
class PassRequest {
  final String teacher;
  final String passType;
  final String requestedAt;
  final String expiresAt;
  final String message;
  final String time;
  final bool urgent;
  final IconData icon;
  final String classUUID;
  final String passUUID;

  PassRequest({
    required this.teacher,
    required this.passType,
    required this.requestedAt,
    required this.expiresAt,
    this.message = '',
    this.urgent = false,
    required this.time,
    required this.icon,
    required this.classUUID,
    required this.passUUID,
  });
}

class ActivePass {
  String _destination;
  final String date;
  final bool isEditable;

  void set destination(String destination) {
    _destination = destination;
  }

  String get destination => _destination;

  ActivePass(this._destination, this.date, this.isEditable);
}
