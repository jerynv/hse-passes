import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hse_apps/assets/variables.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/error.dart';
import 'package:hse_apps/pages/tabs/passes.dart';
import 'package:hse_apps/theme/theme.dart';

class WebSocketProvider extends ChangeNotifier {
  static late WebSocket _webSocket;
  static bool _isConnected = false;
  static bool verified = false;
  static Function update = () {};
  static BuildContext? context;
  static List<dynamic?> incomingPassRequests = [];
  static List<dynamic?> outgoingPassRequest = [];
  static List<dynamic> currentPasses = [];
  static List<dynamic> studentPasses = [];
  static List<dynamic> passRequest = [];
  static List<dynamic> passPresets = [];
  static List<dynamic> teachers = [];
  static List<dynamic> students = [];

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
            String operation = jsonData['operation'];
            switch (operation) {
              case 'verifyIntegrity':
                if (jsonData['data']["success"] == true) {
                  verified = true;
                  _update();
                  debugPrint('User verified');
                }
                break;
              case 'PassRequest':
                debugPrint('Pass request received');
                if (jsonData['data']["success"] == true) {
                  debugPrint('Pass request success');
                  var passRequest = jsonData['data']["pass"];
                  debugPrint('Pass request: $passRequest');
                  incomingPassRequests.add(passRequest);
                  debugPrint('Pass request received: $passRequest');
                  _update();
                } else {
                  debugPrint('Pass request failed');
                }
                break;
              case 'SetPassPresets':
                debugPrint('Pass presets received');
                var passPresetsData = jsonData['data']["passPresets"];
                debugPrint('Pass presets: $passPresetsData');
                passPresets = passPresetsData;
                break;
              case 'PassRequestResponse':
                debugPrint('Pass request response received');
                if (jsonData['data']["success"] == true) {
                  debugPrint('Pass request response success');
                  var passRequestResponse = jsonData['data']["pass"] as Map;
                  debugPrint('Pass request response: $passRequestResponse');
                  outgoingPassRequest.add(passRequestResponse);
                  _update();
                } else {
                  debugPrint('Pass request response failed');
                }
                break;
              case 'SetTeachers':
                debugPrint('Teachers received');
                var teachersData =
                    jsonData['data']["Teachers"] as List<dynamic>;
                debugPrint('Teachers: $teachersData');
                teachers = teachersData;
                break;
              case 'SetStudents':
                debugPrint('Students received');
                var studentsData =
                    jsonData['data']["Students"] as List<dynamic>;
                debugPrint('Students: $studentsData');
                students = studentsData;
                break;
              case "PendingPassRequestDump":
                debugPrint('Pending pass request dump received');
                if (jsonData['data']["success"] == true) {
                  debugPrint('Pending pass request dump success');
                  var pendingPassRequestDump =
                      jsonData['data']["passes"] as List<dynamic>;
                  debugPrint(
                      'Pending pass request dump: $pendingPassRequestDump');
                  incomingPassRequests = pendingPassRequestDump;
                  _update();
                } else {
                  debugPrint('Pending pass request dump failed');
                }
                break;
              case 'SetActivePasses':
                debugPrint('Active passes received');
                var activePassesData =
                    jsonData['data']["ActivePasses"] as List<dynamic>;
                debugPrint('Active passes: $activePassesData');
                currentPasses = activePassesData;
                _update();
                break;
              case 'SetOutGoingRequests':
                debugPrint('Outgoing requests received');
                var outgoingRequests =
                    jsonData['data']["OutGoingRequests"] as List<dynamic>;
                debugPrint('Outgoing requests: $outgoingRequests');
                outgoingPassRequest = outgoingRequests;
                break;
              case 'PassAcceptResponse':
                debugPrint('Pass accept response received');
                if (jsonData['data']["success"] == true) {
                  debugPrint(
                      'Pass accept response success' + jsonData.toString());
                  var passAcceptResponse = jsonData['data']["pass"] as Map;
                  var passId = passAcceptResponse["PassId"];
                  if (Auth.userData!["role"] == "Student") {
                    if (passAcceptResponse["SenderId"] == Auth.loginId) {
                      passAcceptResponse["Destination"] = passAcceptResponse["PassName"];
                    }
                  }
                  incomingPassRequests
                      .removeWhere((element) => element["PassId"] == passId);
                  currentPasses.add(passAcceptResponse);
                  _update();
                } else {
                  debugPrint('Pass accept response failed');
                }
                break;
              case 'PassUpdate':
                debugPrint('Pass update received');
                if (jsonData['data']["success"] == true) {
                  debugPrint('Pass update success');
                  var passUpdate = jsonData['data']["pass"] as Map;
                  var passId = passUpdate["PassId"];
                  if (Auth.userData!["role"] == "Student") {
                    if (passUpdate["SenderId"] == Auth.loginId) {
                      passUpdate["Destination"] = passUpdate["PassName"];
                    }
                    currentPasses.add(passUpdate);
                  }
                  if (Auth.userData!["role"] == "Teacher") {
                    if(passUpdate["SenderId"] == Auth.loginId){
                      passUpdate["PassType"] =  "Upon My Request";
                    }
                  }
                  //remove from outgoingpassrequests
                  outgoingPassRequest
                      .removeWhere((element) => element["PassId"] == passId);
                  
                  studentPasses.add(passUpdate);
                  _update();
                } else {
                  debugPrint('Pass update failed');
                }
                break;
              case 'ShowError':
                debugPrint('Error received');
                var errorTitle = jsonData['data']["title"];
                var errorMessage = jsonData['data']["message"];
                debugPrint('Error message: $errorMessage');
                ShowErrorDialog(
                  _context()!,
                  errorTitle,
                  errorMessage,
                  'OK',
                  Icons.error,
                  Colors.red,
                  null,
                  () {},
                );
                break;
            }
          }
        },
        onDone: () async {
          debugPrint('WebSocket closed');
          if (_isConnected) {
            await Auth.logout(context: _context()!, error: false);
            Navigator.pushNamedAndRemoveUntil(
                _context()!, '/login', (route) => false);
            ShowErrorDialog(
              _context()!,
              'Connection Lost',
              'The connection to the server has been lost. Please try again later.',
              'OK',
              Icons.connect_without_contact_rounded,
              Colors.amber,
              null,
              () {},
            );
            _isConnected = false;
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _isConnected = false;
        },
      );
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
    }
  }

  static BuildContext? _context() {
    if (context != null) {
      return context;
    } else {
      debugPrint('Context is null');
      return null;
    }
  }

  static void _update() {
    if (context != null) {
      debugPrint('Updating context');
      update();
    } else {
      debugPrint('Context is null');
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

  static Future<void> close() async {
    if (_isConnected) {
      _isConnected = false;
      setUpdateFunction(() {});
      _webSocket.close();
      incomingPassRequests = [];
      outgoingPassRequest = [];
      studentPasses = [];
      passRequest = [];
      teachers = [];
      students = [];
      currentPasses = [];
      passPresets = [];
      verified = false;
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
