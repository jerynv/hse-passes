import 'package:flutter/material.dart';
import 'package:hse_apps/pages/tabs/modals/pending_pass.dart';
import 'package:hse_apps/theme/theme.dart';

class PassesTab extends StatefulWidget {
  const PassesTab({super.key});

  @override
  _PassesTabState createState() => _PassesTabState();
}

class _PassesTabState extends State<PassesTab> {
  // Mock Data for Pending Pass Requests
  final List<PassRequest> pendingRequests = [
    PassRequest(
      teacher: 'Mr. Smith',
      passType: 'Library Pass',
      time: '10:00 AM',
      requestedAt: '10:00 AM',
      expiresAt: '10:30 AM',
      message:
          """Scripts.comBee MovieBy Jerry SeinfeldNARRATOR:(Black screen with text; The sound of buzzing bees can be heard)According to all known lawsof aviation, :there is no way a beeshould be able to fly. :Its wings are too small to getits fat little body off the ground. :The bee, of course, flies anyway :because bees don't carewhat humans think is impossible.BARRY BENSON:(Barry is picking out a shirt)Yellow, black. Yellow, black.Yellow, black. Yellow, black. :Ooh, black and yellow!Let's shake it up a little.JANET BENSON:Barry! Breakfast is ready!BARRY:Coming! :Hang on a second.(Barry uses his antenna like a phone) :Hello?ADAM FLAYMAN:(Through phone)- Barry?BARRY:- Adam?ADAM:- Can you believe this is happening?BARRY:- I can't. I'll pick you up.(Barry flies down the stairs) :MARTIN BENSON:Looking sharp.JANET:Use the stairs. Your fatherpaid good money for those.BARRY:Sorry. I'm excited.MARTIN:Here's the graduate.We're very proud of you, son. :A perfect report card, all B's.JANET:Very proud.(Rubs Barry's hair)BARRY=Ma! I got a thing going here.JANET:- You got lint on your fuzz.BARRY:- Ow! That's me!JANET:- Wave to us! We'll be in row 118,000.- Bye!(Barry flies out the door)JANET:Barry, I told you,stop flying in the house!(Barry drives through the hive,and is waved at by Adam who is reading anewspaper)BARRY==- Hey, Adam.ADAM:- Hey, Barry.(Adam gets in Barry's car) :- Is that fuzz gel?BARRY:- A little. Special day, graduation.ADAM:Never thought I'd make it.(Barry pulls away from the house and continues driving)BARRY:Three days grade school,three days high school...ADAM:Those were awkward.BARRY:Three days college. I'm glad I tooka day and hitchhiked around the hive.ADAM==You did come back different.(Barry and Adam pass by Artie, who is jogging)ARTIE:- Hi, Barry!BARRY:- Artie, growing a mustache? Looks good.ADAM:- Hear about Frankie?BARRY:- Yeah.ADAM==- You going to the funeral?BARRY:- No, I'm not going to his funeral. :Everybody knows,sting someone, you die. :Don't waste it on a squirrel.Such a hothead.ADAM:I guess he could havejust gotten out of the way.(The car does a barrel roll on the loop-shaped bridge and lands on thehighway) :I love this """,
      icon: Icons.person,
    ),
    PassRequest(
        teacher: 'Ms. Johnson',
        passType: 'Bathroom Pass',
        time: '10:00 AM',
        requestedAt: '11:15 AM',
        expiresAt: '11:25 AM',
        urgent: true,
        icon: Icons.bathroom_rounded),
    PassRequest(
      teacher: 'Dr. Adams',
      passType: 'Science Lab Pass',
      time: '10:00 AM',
      requestedAt: '1:00 PM',
      expiresAt: '1:45 PM',
      icon: Icons.person,
    ),
    PassRequest(
      teacher: 'Mrs. Lee',
      passType: 'Art Room Pass',
      time: '10:00 AM',
      requestedAt: '9:30 AM',
      expiresAt: '10:00 AM',
      message: 'Student needs to finish their art project.',
      icon: Icons.person,
    ),
    PassRequest(
      teacher: 'Dr. Adams',
      passType: 'Science Lab Pass',
      time: '10:00 AM',
      requestedAt: '1:00 PM',
      expiresAt: '1:45 PM',
      icon: Icons.person,
    ),
    PassRequest(
      teacher: 'Mrs. Lee',
      passType: 'Art Room Pass',
      time: '10:00 AM',
      requestedAt: '9:30 AM',
      expiresAt: '10:00 AM',
      message: 'Student needs to finish their art project.',
      icon: Icons.person,
    ),
  ];
  final incomingScrollController = ScrollController();
  final activeScrollController = ScrollController();
  // Mock Data for Active Passes
  List<ActivePass> activePasses = [
    ActivePass('Math Class', '8:30 - 9:57', false),
    ActivePass('Library', '8:47 - 9:57', true)
  ];

  String _formatTime(TimeOfDay time) {
    // Converts TimeOfDay to a string with AM/PM format
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  void acceptRequest(int index, TimeOfDay time) {
    final formattedTime = _formatTime(time); // AM/PM formatted time
    setState(() {
      activePasses.add(ActivePass(
          pendingRequests[index].teacher, 'Today, $formattedTime', true));
      pendingRequests.removeAt(index);
    });
  }

  void rejectRequest(int index) {
    setState(() {
      pendingRequests.removeAt(index);
    });
  }

  @override
  void dispose() {
    incomingScrollController.dispose();
    activeScrollController.dispose();

    super.dispose();
  }

  void _show_request_modal(
      BuildContext context, PassRequest request, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PendingPassRequestModal(
          passRequest: request,
          onAccept: () {
            Navigator.pop(context); // Close modal
            acceptRequest(index, TimeOfDay.now()); // Call accept logic
          },
          onReject: () {
            Navigator.pop(context); // Close modal
            rejectRequest(index); // Call reject logic
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var timeHour = TimeOfDay.now().hour;
    final brightness = Theme.of(context).brightness;
    String timeOfDay = timeHour < 12
        ? 'Morning'
        : timeHour < 17
            ? 'Afternoon'
            : 'Evening';
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              //min height to prevent overflow
              padding: const EdgeInsets.all(5),
              constraints: const BoxConstraints(minHeight: 150, maxHeight: 370),

              width: double.infinity,
              decoration: BoxDecoration(
                color: main_color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Brightness.dark == brightness
                        ? Colors.grey.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Good $timeOfDay, Jeryn Vicari',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    activePasses.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Passes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: opaque_white_text
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                //set max height the space left
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: RawScrollbar(
                                    thumbVisibility: true,
                                    thumbColor: brightness == Brightness.dark
                                        ? Colors.grey[700]
                                        : Colors.grey[400],
                                    radius: const Radius.circular(10),
                                    controller: activeScrollController,
                                    scrollbarOrientation:
                                        ScrollbarOrientation.right,
                                    child: SingleChildScrollView(
                                        controller: activeScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            children: [
                                              for (var pass in activePasses)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: brightness ==
                                                            Brightness.dark
                                                        ? Colors.grey[900]
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        pass.destination,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        pass.date,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? secondary_text_color_dark
                                                              : secondary_text_color_dark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ))),
                              ),
                            ],
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'You have no active',
                              style: TextStyle(
                                fontSize: 14,
                                color: brightness == Brightness.dark
                                    ? secondary_text_color_dark
                                    : secondary_text_color,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Incoming Passes',
              style: TextStyle(
                fontSize: 16,
                color: brightness == Brightness.dark
                    ? Colors.white
                    : secondary_text_color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          pendingRequests.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: RawScrollbar(
                      controller: incomingScrollController,
                      thumbColor: brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[400],
                      thumbVisibility: true,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        controller: incomingScrollController,
                        physics: const ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: pendingRequests
                              .map((request) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        ),
                                        child: ListTile(
                                          //if first item top pading is 0
                                          contentPadding: pendingRequests
                                                      .indexOf(request) ==
                                                  0
                                              ? const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10,
                                                )
                                              : const EdgeInsets.only(
                                                  bottom: 10,
                                                  right: 10,
                                                  left: 10,
                                                  top: 10),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                main_color.withOpacity(0.2),
                                            child: Icon(
                                              request.icon,
                                              color: main_color,
                                            ),
                                          ),
                                          trailing: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  main_color.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: TextButton(
                                                onPressed: () {
                                                  _show_request_modal(
                                                      context,
                                                      request,
                                                      pendingRequests
                                                          .indexOf(request));
                                                },
                                                child: const Text(
                                                  'Accept',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                          ),
                                          title: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(request.teacher,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                                Text(request.passType,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: brightness ==
                                                              Brightness.dark
                                                          ? secondary_text_color_dark
                                                          : secondary_text_color,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      (pendingRequests.indexOf(request) ==
                                              pendingRequests.length - 1)
                                          ? const SizedBox(height: 20)
                                          : Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Divider(
                                                                            color: brightness == Brightness.dark
                                                                                ? Colors.grey[900]
                                                                                : Colors.grey[300],
                                            
                                                                                
                                                                            height: 1,
                                                                          ),
                                          ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'You have no pending requests',
                    style: TextStyle(
                      fontSize: 14,
                      color: brightness == Brightness.dark
                          ? secondary_text_color_dark
                          : secondary_text_color,
                    ),
                  ),
                ),
        ]),
      ),
    );
  }
}

// Data Classes
class PassRequest {
  final String teacher;
  final String passType;
  final String requestedAt;
  final String expiresAt;
  final String message;
  final String time;
  final bool urgent;
  final IconData icon;

  PassRequest({
    required this.teacher,
    required this.passType,
    required this.requestedAt,
    required this.expiresAt,
    this.message = '',
    this.urgent = false,
    required this.time,
    required this.icon,
  });
}

class ActivePass {
  final String destination;
  final String date;
  final bool isEditable;

  ActivePass(this.destination, this.date, this.isEditable);
}
