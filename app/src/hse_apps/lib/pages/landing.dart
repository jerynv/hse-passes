// staful page setup please

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hse_apps/theme/theme.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int landingIndex = 0;
  PageController landingController = PageController();
  Map<int, Map<String, String>> pages = {
    0: {
      'title': 'Never Worry Again by Using Hse Passes',
      'subtitle': 'We are here to help you!',
      'image': 'assets/images/landing_1.jpg',
    },
    1: {
      'title': 'Connect With Any Teacher In The School',
      'subtitle': 'anytime, anywhere',
      'image': 'assets/images/landing_3.jpg',
    },
    2: {
      'title': 'Get Your Passes Instantly.',
      'subtitle': '',
      'image': 'assets/images/landing_2.jpg',
    },
    3: {
      'title': 'Now Lets Get You Started',
      'subtitle': '',
      'image': 'assets/images/landing_4.jpg',
    },
  };

  @override
  Widget build(BuildContext context) {
    var isdark = Theme.of(context).brightness == Brightness.dark;
    var pageTitle = pages[landingIndex]!["title"]!.split(' ');

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      // decoration: BoxDecoration(color: Colors.red),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image at the top of the page
          Container(
            height: 400,
            child: PageView(
                controller: landingController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //list all the images in the pages map
                  for (var i = 0; i < pages.keys.length; i++)
                    Image.asset(
                      pages[i]!["image"]!,
                      key: ValueKey(i),
                      width: double.infinity,
                    ),
                ]),
          ),

          RichText(
            text: TextSpan(
                //get all but the last word of the title
                text: pageTitle.sublist(0, pageTitle.length - 1).join(' '),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: isdark ? Colors.white : Colors.black,
                ),
                children: [
                  TextSpan(
                    text: ' ${pageTitle.last}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: main_color,
                    ),
                  ),
                ]),
          ),
          const SizedBox(height: 16),
          Text("We are here to help you!",
              style: TextStyle(
                color: isdark ? Colors.white.withOpacity(.5) : Colors.grey,
              )),
          Text("Connect with any teacher in the school",
              style: TextStyle(
                color: isdark ? Colors.white.withOpacity(.5) : Colors.grey,
              )),
          const SizedBox(height: 80),
          Row(
            children: [
              Container(
                child: Row(
                  //3 container to show progress through info screen
                  children: [
                    buildProgressIndicator(
                        pages.keys.length, landingIndex, isdark),
                  ],
                ),
              ),
              const Spacer(),
              //circle button with arrow that incrments the landingIndex
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (landingIndex >= pages.keys.length - 1) {
                      // Navigator.pushReplacementNamed(context, '/login');
                      Navigator.pushReplacementNamed(context, '/login');
                      return;
                    }
                    landingIndex++;
                    landingController.animateToPage(landingIndex,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubicEmphasized);
                  });
                },
                child: Container(
                  height: 55,
                  width: landingIndex >= pages.keys.length - 1 ? 150 : 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: main_color,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: landingIndex >= pages.keys.length - 1
                      ? Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    ));
  }
}

Widget buildProgressIndicator(int amount, int index, bool isDark) {
  //return three conatiner and the active one corisponding to the index having a wider width and being the main coler instaed of eather white with opacity of .5 or grey
  List<Widget> containers = [];
  Widget buildContainer(active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: active ? 20 : 10,
      height: 5,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: active
            ? main_color
            : isDark
                ? Colors.white.withOpacity(.5)
                : Colors.black.withOpacity(.2),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  for (int i = 0; i < amount; i++) {
    if (i == index) {
      containers.add(buildContainer(true));
    } else {
      containers.add(buildContainer(false));
    }
  }

  return Row(children: [
    ...containers,
  ]);
}
