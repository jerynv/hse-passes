import 'package:flutter/material.dart';
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

  final List<Widget> _pages = [
    const PassesTab(),
    const RequestsTab(),
    const ClockTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
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
                  padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
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
                            label: 'Passes',
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
                            label: 'Requests',
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
                            label: 'Clock',
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
                            label: 'Settings',
                          ),
                        ],
                        backgroundColor: Colors.transparent,
                        selectedItemColor:
                            Brightness.dark == Theme.of(context).brightness
                                ? Colors.white
                                : Colors.black,
                        unselectedItemColor:
                            Brightness.dark == Theme.of(context).brightness
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
