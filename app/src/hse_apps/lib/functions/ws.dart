import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hse_apps/assets/variables.dart';
import 'package:hse_apps/pages/tabs/passes.dart';
import 'package:hse_apps/theme/theme.dart';

class WebSocketProvider extends ChangeNotifier {
  static late WebSocket _webSocket;
  static bool _isConnected = false;
  static bool verified = false;
  static late Function update;
  static BuildContext? context;
  static List<PassRequest> passRequests = [];

  static void setUpdateFunction(Function updateFunction) {
    update = updateFunction;
  }

  static void setContext(BuildContext? ctx) {
    context = ctx;
  }

  static Future<void> connect() async {
    try {
      _webSocket = await WebSocket.connect(WS_SERVER);
      _isConnected = true;
      debugPrint('WebSocket connected');
      _webSocket.listen(
        (data) {
          debugPrint('Received data: $data');
          if (data != null) {
            var jsonData = jsonDecode(data);
            String operation = jsonData['Operation'];
            switch (operation) {
              case 'verifyIntegrity':
                if (jsonData['Data']["success"] == true) {
                  verified = true;
                  update();
                  debugPrint('User verified');
                }
                break;
              case 'PassRequest':
                if (jsonData['Data']["success"] == true) {
                  var passRequest = jsonData['Data']["passRequest"];
                  passRequests.add(passRequest);
                  debugPrint('Pass request received: $passRequest');
                  update();
                } else {
                  debugPrint('Pass request failed');
                }
                break;
            }

          }
        },
        onDone: () {
          debugPrint('WebSocket closed');
          Navigator.pushReplacementNamed(
            context!,
            '/login',
          );
          showDialog(
            context: context!,
            builder: (context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.amber,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text('Session terminated',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                content: const Text(
                    'Your session has been terminated. This could be due to a timeout or a secondary login from another device.'),
                actions: [
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
                        },
                        child: const Text(
                          'OK',
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
          _isConnected = false;
          return;
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _isConnected = false;
          return;
        },
      );
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      return;
    }
  }

  static void send(String message) {
    //check to see if the message is valid json
    try {
      var a = jsonDecode(message);
    } catch (e) {
      debugPrint('Invalid JSON: $message');
      return;
    }

    if (_isConnected) {
      _webSocket.add(message);
      debugPrint('Sent message: $message');
    } else {
      debugPrint('WebSocket is not connected');
    }
  }

  static void close() {
    if (_isConnected) {
      _webSocket.close();
      _isConnected = false;
      setUpdateFunction(() {});
      setContext(null);
      debugPrint('WebSocket closed');
    }
  }

  static bool isConnected() {
    return _isConnected;
  }

  static void reconnect() {
    if (!_isConnected) {
      connect();
    }
  }
}
