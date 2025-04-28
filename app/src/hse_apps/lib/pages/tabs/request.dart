import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/ws.dart';
import 'package:hse_apps/theme/theme.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<RequestsTab> {
  final List<PassType> passTypes = [
    PassType(
      icon: Icons.wc,
      description: 'Bathroom',
      assName: '[Teacher\'s Name]',
    ),
    PassType(
      icon: Icons.local_drink_outlined,
      description: 'Water',
      assName: '[Teacher\'s Name]',
    ),
    PassType(
      icon: Icons.directions_walk,
      description: 'Hall Pass',
      assName: '[Teacher\'s Name]',
    ),
    // Subject-Specific Pass Types
    PassType(
      icon: Icons.computer,
      description: 'Library Pass',
      assName: 'Librarian',
    ),
    PassType(
      icon: Icons.science,
      description: 'Science Lab',
      assName: '[Science Teacher\'s Name]',
    ),
    PassType(
      icon: Icons.palette,
      description: 'Art Room',
      assName: '[Art Teacher\'s Name]',
    ),
    PassType(
      icon: Icons.music_note,
      description: 'Music Room',
      assName: '[Music Teacher\'s Name]',
    ),

    // Special Needs Pass Types
    PassType(
      icon: Icons.local_hospital,
      description: 'Nurse',
      assName: '[Nurse\'s Name]',
    ),
    PassType(
      icon: Icons.account_box,
      description: 'Guidance',
      assName: '[Counselor\'s Name]',
    ),
    PassType(
      icon: Icons.accessibility,
      description: 'Special Ed',
      assName: '[Special Education Teacher\'s Name]',
    ),

    // Administrative Pass Types
    PassType(
      icon: Icons.school,
      description: 'Principal\'s Office',
      assName: '[Principal\'s Name]',
    ),
    PassType(
      icon: Icons.mail,
      description: 'Office Pass',
      assName: '[Office Staff Name]',
    ),
  ];
  List<PassType> filteredPassTypes = [];

  final FocusNode _focusNode = FocusNode();
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    filteredPassTypes = passTypes;

    // Add listener to update focus state
    _focusNode.addListener(() {
      setState(() {
        _isInputFocused = _focusNode.hasFocus;
      });
    });
  }

  void filterPassTypes(String query) {
    setState(() {
      filteredPassTypes = passTypes
          .where((passType) =>
              passType.description
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              passType.assName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor:
          brightness == Brightness.dark ? main_color_dark : Colors.grey[100],
      body: Column(
        children: [
          SizedBox(
            height: _isInputFocused ? 50 : 400,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: _isInputFocused ? Colors.transparent : main_color,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0, top: 70, right: 30),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Request a Pass ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(Icons.arrow_downward,
                                  color: Colors.white, size: 50),
                            ),
                          ],
                        ),
                      )),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Container(
                          height: 160, //
                          decoration: BoxDecoration(
                            color: _isInputFocused
                                ? Colors.transparent
                                : Brightness.dark == brightness
                                    ? main_container_color_dark
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Brightness.dark == brightness
                                    ? Colors.grey.withOpacity(0.05)
                                    : Colors.grey.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "No Outgoing Passes",
                              style: TextStyle(
                                color: _isInputFocused
                                    ? Colors.transparent
                                    : Brightness.dark == brightness
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pass Details",
                  style: TextStyle(
                    color: secondary_text_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  elevation: 1,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: Colors.transparent,
                  child: TextField(
                    focusNode: _focusNode, // Attach the focus node
                    onChanged: filterPassTypes,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      fillColor: Brightness.dark == brightness
                          ? main_container_color_dark
                          : Colors.white,
                      filled: true,
                      focusColor: Brightness.dark == brightness
                          ? Colors.black
                          : Colors.white,
                      prefixIcon: Icon(
                        Icons.search,
                        color: secondary_text_color,
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: secondary_text_color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredPassTypes
                      .map((passType) => Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                leading: CircleAvatar(
                                  backgroundColor: main_color.withOpacity(0.2),
                                  child: Icon(
                                    passType.icon,
                                    color: main_color,
                                  ),
                                ),
                                trailing: Container(
                                  width: 90,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: main_color.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        WebSocketProvider.send(jsonEncode({
                                          "Operation": "SendPassRequest",
                                          "Data": {
                                            "id": Auth.loginId,
                                            "token": Auth.loginBearerToken,
                                            "PassType": passType.description,
                                            "PassName": passType.assName,
                                          }
                                        }));
                                      },
                                      child: const Text(
                                        'Request',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                                title: Text(
                                  passType.description,
                                  style: TextStyle(
                                    color: secondary_text_color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(
                                color: brightness == Brightness.dark
                                    ? Colors.grey[900]
                                    : Colors.grey[300],
                                height: 1,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
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
