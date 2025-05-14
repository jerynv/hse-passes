import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:hse_apps/pages/login.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ErrorTab extends StatefulWidget {
  const ErrorTab({super.key});

  @override
  State<ErrorTab> createState() => SettingsTabState();
}

class SettingsTabState extends State<ErrorTab> {
  bool pushNotificationsSwitch = false;
  @override
  Widget build(BuildContext context) {
    bool darkModeSwitch =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    final brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'An error has occurred. Please try again later.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: main_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
