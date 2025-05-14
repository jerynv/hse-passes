import 'package:flutter/material.dart';
import 'package:hse_apps/theme/theme.dart';

void ShowErrorDialog(
  BuildContext context,
  String title,
  String message,
  String? buttonText,
  IconData? icon,
  Color? iconColor,
  bool? Dark,
  Function() onPressed,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsPadding: const EdgeInsets.all(15),
        title: Row(
          children: [
            Icon(
              icon ?? Icons.warning,
              color: iconColor ?? Colors.red,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        content: Text(message),
        actions: <Widget>[
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
                  Navigator.of(context).pop();
                  onPressed();
                },
                child: Text(
                  buttonText ?? 'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ),
        ],
      );
    },
  );
}
