import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hse_apps/functions/Schedule.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/ws.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<RequestsTab> {
  List<dynamic> filteredPasses = [];
  Timer? dis;

  final FocusNode _focusNode = FocusNode();
  bool _isInputFocused = false;
  List<dynamic?> outgoingPassRequest = [];

  void init() {
    debugPrint('hi there');
    WebSocketProvider.setUpdateFunction(() {
      setState(() {
        outgoingPassRequest = WebSocketProvider.outgoingPassRequest;
      });
    });
    outgoingPassRequest = WebSocketProvider.outgoingPassRequest;
  }

  @override
  void initState() {
    super.initState();
    init();
    _focusNode.addListener(() {
      setState(() {
        _isInputFocused = _focusNode.hasFocus;
      });
    });
    filteredPasses = WebSocketProvider.passPresets;
    //if passPresets is empty, retry after 2 sconds until it isnt
    if (WebSocketProvider.passPresets.isEmpty) {
      dis = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (WebSocketProvider.passPresets.isEmpty) {
          filteredPasses = WebSocketProvider.passPresets;
          timer.cancel();
        }
      });
    }
  }

  void filterPassTypes(String query) {
    //map websocket.teachers to the passname and description by name being The id and description being the name

    List<dynamic> searchableTeachers = WebSocketProvider.teachers
        .map((teacher) => {
              "Description": teacher['TeacherName'],
              "Name": teacher['TeacherId'],
            })
        .toList();
    filteredPasses = WebSocketProvider.passPresets
            .where((passType) =>
                passType['Description']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                passType['Name'].toLowerCase().contains(query.toLowerCase()))
            .toList() +
        searchableTeachers
            .where((passType) =>
                passType['Description']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                passType['Name'].toLowerCase().contains(query.toLowerCase()))
            .toList();

    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
    if (dis != null) {
      dis!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    double safeAreaTop = 70;
    int timeHour = TimeOfDay.now().hour;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String timeOfDay = timeHour < 12
        ? 'morning'
        : timeHour < 17
            ? 'afternoon'
            : 'evening';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: safeAreaTop,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isInputFocused
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Passes',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      (Auth.userData?["firstName"] ?? 'first') +
                          // ignore: prefer_interpolation_to_compose_strings
                          (' ' + (Auth.userData?["lastName"] ?? 'last')),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: TextField(
              onChanged: (e) {
                filterPassTypes(e);
              },
              focusNode: _focusNode,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Search pass...',
                prefixIconConstraints:
                    const BoxConstraints(maxHeight: double.infinity),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10),
                  child: Icon(
                    FluentIcons.search_28_regular,
                    color: _isInputFocused ? main_color : Colors.grey,
                  ),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? main_color.withOpacity(.2)
                    : main_color.withOpacity(.1),
              ),
            ),
          ),
          _isInputFocused
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  //height: 200,
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                          text: TextSpan(
                        text: 'You Have',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(.8),
                        ),
                        children: [
                          TextSpan(
                            text:
                                ' ${outgoingPassRequest.isNotEmpty ? '${outgoingPassRequest.length} Outgoing ${outgoingPassRequest.length > 1 ? "Passes" : "Pass"}' : 'No Outgoing Passes'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                      outgoingPassRequest.isNotEmpty
                          //create text for each pass outgoing request
                          ? Column(
                              children: [
                                for (var pass in outgoingPassRequest)
                                  //return list of passes
                                  Container(
                                    //with blury backdrop
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          pass?['PassName'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                          pass?['PassTime'])
                                                      .toLocal()
                                                      .hour
                                                      .toString() +
                                                  ':' +
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          pass?['PassTime'])
                                                      .toLocal()
                                                      .minute
                                                      .toString()
                                                      .padLeft(2, '0'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              splashColor: Colors.red,
                                              splashFactory:
                                                  InkSplash.splashFactory,
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                debugPrint(
                                                    'cancel pass request');
                                              },
                                              child: Container(
                                                color: Colors.white
                                                    .withOpacity(.2),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 10,
                                                  color: Colors.white
                                                      .withOpacity(.8),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
          const SizedBox(height: 20),

          //dynamic scrollable list of passes

          Expanded(
              child: ListView.builder(
            itemCount: filteredPasses.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  WebSocketProvider.send(json.encode({
                    "operation": "SendPassRequest",
                    "data": {
                      "classUUID": Auth.userData?['classes'][getCurrentPeriod()]
                          .toString(),
                      "refId": Auth.loginId.toString(),
                      "passName": filteredPasses[index]['displayName'],
                      "passType": filteredPasses[index]['Name'],
                      //teacher id of current period
                      "receiverId": Auth.userData?['classInfo']
                          [getCurrentPeriod()]['teacherId'],
                    }
                  }));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? main_container_color_dark : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.white.withOpacity(.05)
                            : Colors.grey.withOpacity(.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        filteredPasses[index]['displayName'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      //arrow icon inside small circle
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? main_color.withOpacity(.1)
                              : main_color.withOpacity(.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          FluentIcons.ios_arrow_rtl_24_regular,
                          size: 15,
                          color: isDarkMode
                              ? Colors.white.withOpacity(.8)
                              : Colors.black.withOpacity(.3),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

class PassType {
  final IconData icon;
  final String description;
  final String assName;

  PassType({
    required this.icon,
    required this.description,
    required this.assName,
  });
}
