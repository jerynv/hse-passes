import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hse_apps/pages/tabs/passes.dart';
import 'package:hse_apps/theme/theme.dart';

class PendingPassRequestModal extends StatefulWidget {
  const PendingPassRequestModal({super.key, required this.passRequest, required this.onAccept, required this.onReject});

  final PassRequest passRequest;
  final  Function onAccept;
  final  Function onReject;

  @override
  _PendingPassRequestModalState createState() =>
      _PendingPassRequestModalState();
}

class _PendingPassRequestModalState extends State<PendingPassRequestModal> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final passrequest = widget.passRequest;
    final message = passrequest.message == '' ? false : true;
    print(message);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? main_container_color_dark 
                : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark ? secondary_Border_color_dark : Colors.grey[400],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            passrequest.teacher,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          passrequest.urgent
                              ? const Row(
                                  children: [
                                    Text(
                                      "Urgent",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      CupertinoIcons.exclamationmark_triangle,
                                      color: Colors.red,
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: brightness == Brightness.dark ? .3 : .6,
                        decoration: BoxDecoration(
                          color: brightness == Brightness.dark
                              ? secondary_Border_color_dark
                              : secondary_Border_color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pass",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? secondary_text_color_dark
                                            : secondary_text_color,
                                      ),
                                    ),
                                    Text(
                                      passrequest.passType,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? primary_text_color_dark
                                            : primary_text_color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Requested at",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? secondary_text_color_dark
                                            : secondary_text_color,
                                      ),
                                    ),
                                    Text(
                                      passrequest.requestedAt,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? primary_text_color_dark
                                            : primary_text_color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Expires at",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? secondary_text_color_dark
                                            : secondary_text_color,
                                      ),
                                    ),
                                    Text(
                                      passrequest.expiresAt,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? primary_text_color_dark
                                            : primary_text_color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Message",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: brightness == Brightness.dark
                                            ? secondary_text_color_dark
                                            : secondary_text_color,
                                      ),
                                    ),
                                    message
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.green)
                                        : const Icon(Icons.close_rounded,
                                            color: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    message
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              //set max height to 100
                              constraints: const BoxConstraints(
                                  maxHeight: 400, minHeight: 100),

                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: brightness == Brightness.dark
                                    ? const Color.fromARGB(255, 27, 27, 27)
                                    : Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: brightness == Brightness.dark
                                      ? secondary_Border_color_dark
                                      : secondary_Border_color,
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  passrequest.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: brightness == Brightness.dark
                                        ? primary_text_color_dark
                                        : primary_text_color,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Accept logic here
                          widget.onAccept();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
