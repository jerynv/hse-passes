import 'package:flutter/material.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  RequestState createState() => RequestState();
}

class RequestState extends State<RequestsTab> {
  final List<PassType> passTypes = [
    // Basic Pass Types
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

  @override
  void initState() {
    super.initState();
    filteredPassTypes = passTypes; // Initialize with all pass types
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor:
          brightness == Brightness.dark ? Colors.black : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Search Pass Types',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: filteredPassTypes.map((passType) {
                  return Card(
                    elevation: 5,
                    child:
                      ListTile(
                        
                        contentPadding: const EdgeInsets.all(8),
                        leading: Icon(passType.icon),
                        title: Text(passType.description),
                        subtitle: Text('Assigned to: ${passType.assName}'),
                        onTap: () {},
                      ),
                    
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
