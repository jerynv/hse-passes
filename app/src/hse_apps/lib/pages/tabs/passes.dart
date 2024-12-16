import 'package:flutter/material.dart';

class PassesTab extends StatefulWidget {
  const PassesTab({super.key});

  @override
  _PassesTabState createState() => _PassesTabState();
}

class _PassesTabState extends State<PassesTab> {
  // Mock Data for Pending Pass Requests
  List<PassRequest> pendingRequests = [
    PassRequest('Mr. Smith', '5 min ago'),
    PassRequest('Ms. Johnson', '10 min ago'),
  ];

  // Mock Data for Active Passes
  List<ActivePass> activePasses = [
    ActivePass('Math Class', 'Mon, 25th June'),
    ActivePass('Library', 'Tue, 26th June'),
  ];

  void acceptRequest(int index) {
    setState(() {
      activePasses.add(ActivePass(pendingRequests[index].teacher, 'Today'));
      pendingRequests.removeAt(index);
    });
  }

  void rejectRequest(int index) {
    setState(() {
      pendingRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Passes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
                const Text('No pending requests')
              else
                Column(
                  children: pendingRequests.asMap().entries.map((entry) {
                    int index = entry.key;
                    PassRequest request = entry.value;
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(request.teacher),
                        subtitle: Text(request.time),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => acceptRequest(index),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () => rejectRequest(index),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
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
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(pass.destination[0]),
                        ),
                        title: Text(pass.destination),
                        subtitle: Text(pass.date),
                        trailing: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    );
                  }).toList(),
                ),
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

  ActivePass(this.destination, this.date);
}
