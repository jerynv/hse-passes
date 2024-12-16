import 'package:flutter/material.dart';

class PassesTab extends StatefulWidget {
  const PassesTab({super.key});

  @override
  _PassesTabState createState() => _PassesTabState();
}

class _PassesTabState extends State<PassesTab> {
  // Mock Data for Pending Pass Requests
  List<PassRequest> pendingRequests = [

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

  void addPassRequest(String teacher) {
    setState(() {
      pendingRequests.add(PassRequest(teacher, 'Just now'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
        
          children: [
            
            TextButton(
                onPressed: () => addPassRequest("teacher"),
                child: const Text(
                  "My Passes",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 24), 
                  textAlign: TextAlign.left,
                )),
          ],
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
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[500],
                              child: Text(request.teacher[0]),
                            ),
                            title: Text(request.teacher),
                            subtitle: Text(request.time),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () =>
                                        acceptRequest(index, TimeOfDay.now()),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => rejectRequest(index),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 217, 217),
                                      foregroundColor:
                                          const Color.fromARGB(255, 255, 0, 0),
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
  final String time;

  PassRequest(this.teacher, this.time);
}

class ActivePass {
  final String destination;
  final String date;
  final bool isEditable;

  ActivePass(this.destination, this.date, this.isEditable);
}
