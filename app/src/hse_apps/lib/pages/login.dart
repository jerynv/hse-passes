// staful page setup please

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_apps/functions/auth.dart';
import 'package:hse_apps/functions/error.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    var isLoggedIn = await Auth.login("251378", "password123");
    if (isLoggedIn) {
      // Navigate to the home page
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (rout) => false,
      );
    } else {
      // Show an error message
      ShowErrorDialog(
        context,
        "Login Failed",
        "Invalid username or password",
        "OK",
        Icons.error,
        Colors.red,
        null,
        () {
          // Handle the error
          _idController.clear();
          _passwordController.clear();
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
                          text: 'Welcome to \n',
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
                      "Student Id",
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
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/teacherLogin', (route) => false);
                            },
                            child: Text("Teacher Login",
                                style: TextStyle(
                                  color: isdark
                                      ? Colors.white.withOpacity(.9)
                                      : Colors.black.withOpacity(.9),
                                )),
                          ),
                        ),
                        Container(
                            height: 20,
                            width: 1,
                            color: isdark
                                ? const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(.5)
                                : const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(.5)),
                        Expanded(
                          child: TextButton(
                              onPressed: () {},
                              child: Text("Create Account",
                                  style: TextStyle(
                                    color: main_color.withOpacity(.9),
                                  ))),
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
