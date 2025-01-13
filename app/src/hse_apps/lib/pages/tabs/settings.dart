import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hse_apps/pages/login.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  bool pushNotificationsSwitch = false;
  @override
  Widget build(BuildContext context) {
    bool darkModeSwitch =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    final brightness = Theme.of(context).brightness;
    return Container(
      width: double.infinity,
      height: double.infinity,
      //gradient of main color and whit
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            main_color,
            brightness == Brightness.dark
                ? Colors.grey[900]!
                : Colors.grey[100]!,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 60,
              color: main_color,
            ),
          ),
          Text("Jeryn Vicari",
              style: TextStyle(
                fontSize: 24,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.white,
              )),
          const SizedBox(height: 10),
          Text("Hamilton Southeastern",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: opaque_white_text)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: brightness == Brightness.dark
                    ? Colors.black
                    : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Settings",
                      style: TextStyle(
                          fontSize: 24,
                          color: brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Account Settings",
                      style: TextStyle(
                          fontSize: 16,
                          color: brightness == Brightness.dark
                              ? secondary_Border_color_dark
                              : secondary_Border_color,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit profile",
                        style: TextStyle(
                            fontSize: 16,
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change password",
                        style: TextStyle(
                            fontSize: 16,
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View history",
                        style: TextStyle(
                            fontSize: 16,
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text("Misc",
                      style: TextStyle(
                          fontSize: 16,
                          color: brightness == Brightness.dark
                              ? secondary_Border_color_dark
                              : secondary_Border_color,
                          fontWeight: FontWeight.w500)),
                  
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pushNotificationsSwitch = !pushNotificationsSwitch;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Push notifications",
                            style: TextStyle(
                                fontSize: 16,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 60,
                            height: 30,
                            alignment: pushNotificationsSwitch
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 4, right: 5),
                            decoration: BoxDecoration(
                              color: pushNotificationsSwitch
                                  ? main_color
                                  : brightness == Brightness.dark
                                      ? secondary_Border_color_dark
                                      : secondary_Border_color,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                pushNotificationsSwitch
                                    ? Icons.notifications_active
                                    : Icons.notifications_off,
                                size: 16,
                                color: pushNotificationsSwitch
                                    ? main_color
                                    : secondary_Border_color,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      darkModeSwitch = !darkModeSwitch;
                      HapticFeedback.lightImpact();
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dark mode",
                            style: TextStyle(
                                fontSize: 16,
                                color: brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 60,
                            height: 30,
                            alignment: darkModeSwitch
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 4, right: 5),
                            decoration: BoxDecoration(
                              color: darkModeSwitch
                                  ? main_color
                                  : secondary_Border_color,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                brightness == Brightness.dark
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                size: 16,
                                color: darkModeSwitch
                                    ? main_color
                                    : secondary_Border_color,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
