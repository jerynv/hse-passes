import 'package:flutter/material.dart';
import 'package:hse_apps/pages/tabs/modals/pending_pass.dart';

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
    ),
    PassRequest(
      teacher: 'Ms. Johnson',
      passType: 'Bathroom Pass',
      time: '10:00 AM',
      requestedAt: '11:15 AM',
      expiresAt: '11:25 AM',
      urgent: true,
    ),
    PassRequest(
      teacher: 'Dr. Adams',
      passType: 'Science Lab Pass',
      time: '10:00 AM',
      requestedAt: '1:00 PM',
      expiresAt: '1:45 PM',
    ),
    PassRequest(
      teacher: 'Mrs. Lee',
      passType: 'Art Room Pass',
      time: '10:00 AM',
      requestedAt: '9:30 AM',
      expiresAt: '10:00 AM',
      message: 'Student needs to finish their art project.',
    ),
    PassRequest(
      teacher: 'Mr. Brown',
      passType: 'Principal\'s Office Pass',
      time: '10:00 AM',
      requestedAt: '2:15 PM',
      expiresAt: '2:45 PM',
      message: 'Principal requested to meet the student.',
    ),
    PassRequest(
      teacher: 'Ms. Thompson',
      passType: 'Guidance Office Pass',
      time: '10:00 AM',
      requestedAt: '3:00 PM',
      expiresAt: '3:30 PM',
      message: 'Student has a counseling session scheduled.',
    ),
  ];

  // Mock Data for Active Passes
  List<ActivePass> activePasses = [
    ActivePass('Math Class', 'Mon, 25th June', false),
    ActivePass('Library', 'Tue, 26th June', true)
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

  void _show_request_modal(
      BuildContext context, PassRequest request, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PendingPassRequestModal(
          passRequest: request,
          onAccept:  () {
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
    var time_hour = TimeOfDay.now().hour;
    String time_of_day = time_hour < 12
        ? 'Morning'
        : time_hour < 17
            ? 'Afternoon'
            : 'Evening';
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good $time_of_day',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const Text(
                    "My Passes",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Brightness.dark == Theme.of(context).brightness
            ? Colors.black
            : Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pending Requests
              const Text(
                'Pending Requests',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (pendingRequests.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'No pending requests',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
              else
                Column(
                  children: pendingRequests.asMap().entries.map((entry) {
                    int index = entry.key;
                    PassRequest request = entry.value;

                    return Card(
                      elevation: 5,
                      color: Brightness.dark == Theme.of(context).brightness
                          ? Colors.grey[900]
                          : Colors.white,
                      shadowColor:
                          Brightness.dark == Theme.of(context).brightness
                              ? const Color.fromARGB(255, 102, 102, 102)
                              : Colors.black,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: request.urgent
                                ? Colors.redAccent
                                : Colors.blueAccent,
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () =>
                              _show_request_modal(context, request, index),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[500],
                                  child: Text(request.teacher[0]),
                                ),
                                title: Text(request.teacher),
                                subtitle: Text(request.time),
                                trailing: const IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 40,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              // Active Passes
              const Text(
                'Active Passes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (activePasses.isEmpty)
                const Text('No active passes')
              else
                Column(
                    children: activePasses.map((pass) {
                  return Card(
                    elevation: 5,
                    color: Brightness.dark == Theme.of(context).brightness
                        ? Colors.grey[900]
                        : Colors.white,
                    shadowColor: Brightness.dark == Theme.of(context).brightness
                        ? const Color.fromARGB(255, 102, 102, 102)
                        : Colors.black,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[500],
                        child: Text(pass.destination[0]),
                      ),
                      title: Text(pass.destination),
                      subtitle: Text(pass.date),
                      trailing: pass.isEditable
                          ? const Text(
                              'Edit',
                              style: TextStyle(color: Colors.blue),
                            )
                          : null,
                    ),
                  );
                }).toList()),
            ],
          ),
        ),
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

  PassRequest({
    required this.teacher,
    required this.passType,
    required this.requestedAt,
    required this.expiresAt,
    this.message = '',
    this.urgent = false,
    required this.time,
  });
}

class ActivePass {
  final String destination;
  final String date;
  final bool isEditable;

  ActivePass(this.destination, this.date, this.isEditable);
}
