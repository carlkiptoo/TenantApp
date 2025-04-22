import 'package:flutter/material.dart';
import 'request_detail_screen.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  //Dummy data
  List<Map<String, dynamic>> requests = [
    {
      'issue': 'Leaking tap in kitchen',
      'status': 'Pending',
      'dateReported': '2025-04-15',
      'adminNotes': '',
      'imagePath': null,
    },
    {
      'issue': 'Broken window in bedroom',
      'status': 'Resolved',
      'dateReported': '2025-04-01',
      'adminNotes': 'Replaced window on 2025-04-02',
      'imagePath': null,
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'In progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body:
          requests.isEmpty
              ? const Center(child: Text('No maintenance history available'))
              : ListView.builder(
                itemCount: requests.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      onTap: () {
                       Navigator.push(context,
                         MaterialPageRoute(builder: (context) => RequestDetailScreen(request: request),
                         ),
                       );
                      },
                      leading: CircleAvatar(
                        backgroundColor: getStatusColor(request['status']),
                        child: Icon(Icons.build, color: Colors.white),
                      ),
                      title: Text(request['issue']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${request['status']}'),
                          Text('Reported: ${request['dateReported']}'),
                          if (request['adminNotes'] != null &&
                              request['adminNotes']!.isNotEmpty)
                            Text('Notes: ${request['adminNotes']}'),
                        ],
                      ),
                      trailing:
                          request['imagePath'] != null
                              ? Icon(Icons.image, color: Colors.grey)
                              : null,
                    ),
                  );
                },
              ),
    );
  }
}
