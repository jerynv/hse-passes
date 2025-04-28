// staful page setup please

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  State<TeacherLoginPage> createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login_page_login() async {
    setState(() {
      isLoading = true;
    });
    var id = _idController.text;
    var password = _passwordController.text;
    //var isLoggedIn = await Auth.login(id, password);
    var isLoggedIn = await Auth.Tlogin("2513780", "password123");
    if (isLoggedIn) {
      // Navigate to the home page
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "teacher": true,
      });
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            content: const Text('Invalid ID or Password'),
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
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isdark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 2,
                  color: main_color,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                // decoration: BoxDecoration(color: Colors.red),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //image at the top of the page

                    RichText(
                      text: TextSpan(
                          //get all but the last word of the title
                          text: 'Welcome Teachers, to \n',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: isdark ? Colors.white : Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Hse Passes!',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: main_color,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 30),
                    createTextField(
                      "Teacher Id",
                      false,
                      _idController,
                      Icons.numbers,
                      isdark,
                    ),
                    createTextField(
                      "Password",
                      true,
                      _passwordController,
                      Icons.lock_outline,
                      isdark,
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        login_page_login();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: main_color,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text("Student Login",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }
}

Widget createTextField(
  String hint,
  bool isPassword,
  TextEditingController controller,
  IconData icon,
  bool isdark,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    padding: EdgeInsets.only(left: 15),
    height: 60,
    width: double.infinity,
    decoration: BoxDecoration(
      color:
          isdark ? Colors.white.withOpacity(.1) : Colors.grey.withOpacity(.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isdark ? Colors.white.withOpacity(.5) : Colors.grey,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            cursorColor: main_color,
            style: TextStyle(
              color: isdark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isdark ? Colors.white.withOpacity(.5) : Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
            ),
          ),
        ),
      ],
    ),
  );
}
