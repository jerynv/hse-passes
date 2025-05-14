import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/error.dart';
import 'package:hse_apps/functions/ws.dart';
import 'package:hse_apps/pages/tabs/TRequest.dart';
import 'package:hse_apps/pages/tabs/class.dart';
import 'package:hse_apps/pages/tabs/error.dart';
import 'package:hse_apps/theme/theme.dart';
import 'tabs/request.dart';
import 'tabs/passes.dart';
import 'tabs/settings.dart';
import 'tabs/clock.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool disposed = false;

  List<Widget> get _pages {
    switch (Auth.userData?["role"]) {
      case 'Student':
        return [
          const PassesTab(),
          const RequestsTab(),
          const ClockTab(),
          const SettingsTab(),
        ];
      case 'Teacher':
        return [
          const ClassTab(),
          const TeacherRequestsTab(),
          const ClockTab(),
          const SettingsTab(),
        ];
      case 'Admin':
        return [
          // const EveryOne(),
          const RequestsTab(),
          const ClockTab(),
          const SettingsTab(),
        ];
      default:
        return [
          const ErrorTab(),
          const ErrorTab(),
          const ErrorTab(),
          const ErrorTab(),
        ];
    }
  }

  final List<String> _studentTabs = [
    'Passes',
    'Request',
    'Clock',
    'Settings',
  ];

  final List<String> _teacherTabs = [
    'Class',
    'Request',
    'Clock',
    'Settings',
  ];

  final List<String> _adminTabs = [
    'Class',
    'Request',
    'Clock',
    'Settings',
  ];

  void connectWebSocket() async {
    debugPrint('Connecting to WebSocket...');
    WebSocketProvider.setUpdateFunction(() {
      setState(() {});
    });
    WebSocketProvider.setContext(context);
    await WebSocketProvider.connect();
    debugPrint('WebSocket finsihed');
    if (WebSocketProvider.isConnected()) {
      WebSocketProvider.send(jsonEncode({
        'operation': 'setUser',
        'data': {
          'refId': Auth.loginId,
        },
      }));
      await Future.delayed(Duration(seconds: 10), () async {
        if (disposed) {
          return;
        }
        debugPrint('for some reason still got here' + WebSocketProvider.verified.toString() + disposed.toString());
        if (!WebSocketProvider.verified) {
          await Auth.logout(error: false, context: context);
          ShowErrorDialog(
            context,
            'Error',
            'User verification failed. Please try again.',
            'OK',
            Icons.error,
            Colors.red,
            null,
            () {
            },
          );
        }
      });
    } else {
      debugPrint('WebSocket not connected');
    }
  }

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: !WebSocketProvider.verified
            ? Scaffold(
                body: Container(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? main_color_dark
                      : Colors.grey[100],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: main_color,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Verifying User...',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? main_color_dark
                    : Colors.grey[100],
                //remove appbar
                body: Column(
                  children: [
                    // Spacer bar
                    Expanded(
                      child: _pages[_currentIndex],
                    ),
                  ],
                ),

                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: .1,
                      width: double.infinity,
                      color: Brightness == Theme.of(context).brightness
                          ? secondary_Border_color_dark
                          : secondary_Border_color,
                    ),
                    Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              currentIndex: _currentIndex,
                              onTap: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    _currentIndex == 0
                                        ? Icons.home
                                        : Icons.home_outlined,
                                    color: _currentIndex == 0
                                        ? Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.white
                                            : Colors.black
                                        : Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.grey[700]
                                            : Colors.grey[400],
                                  ),
                                  label: Auth.userData?["role"] == 'Student'
                                      ? _studentTabs[0]
                                      : Auth.userData?["role"] == 'Teacher'
                                          ? _teacherTabs[0]
                                          : _adminTabs[0],
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    _currentIndex == 1
                                        ? Icons.add_box_rounded
                                        : Icons.add_box_outlined,
                                    color: _currentIndex == 1
                                        ? Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.white
                                            : Colors.black
                                        : Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.grey[700]
                                            : Colors.grey[400],
                                  ),
                                  label: Auth.userData?["role"] == 'Student'
                                      ? _studentTabs[1]
                                      : Auth.userData?["role"] == 'Teacher'
                                          ? _teacherTabs[1]
                                          : _adminTabs[1],
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    _currentIndex == 2
                                        ? Icons.timer_rounded
                                        : Icons.timer_outlined,
                                    color: _currentIndex == 2
                                        ? Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.white
                                            : Colors.black
                                        : Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.grey[700]
                                            : Colors.grey[400],
                                  ),
                                  label: Auth.userData?["role"] == 'Student'
                                      ? _studentTabs[2]
                                      : Auth.userData?["role"] == 'Teacher'
                                          ? _teacherTabs[2]
                                          : _adminTabs[2],
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    _currentIndex == 3
                                        ? Icons.settings_rounded
                                        : Icons.settings_outlined,
                                    color: _currentIndex == 3
                                        ? Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.white
                                            : Colors.black
                                        : Brightness.dark ==
                                                Theme.of(context).brightness
                                            ? Colors.grey[700]
                                            : Colors.grey[400],
                                  ),
                                  label: Auth.userData?["role"] == 'Student'
                                      ? _studentTabs[3]
                                      : Auth.userData?["role"] == 'Teacher'
                                          ? _teacherTabs[3]
                                          : _adminTabs[3],
                                ),
                              ],
                              backgroundColor: Colors.transparent,
                              selectedItemColor: Brightness.dark ==
                                      Theme.of(context).brightness
                                  ? Colors.white
                                  : Colors.black,
                              unselectedItemColor: Brightness.dark ==
                                      Theme.of(context).brightness
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                              selectedFontSize: 12,
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
