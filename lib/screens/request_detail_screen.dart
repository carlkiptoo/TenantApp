import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Issue Reported',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request['description']),
            const SizedBox(height: 16),

            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(request['status']),
            const SizedBox(height: 16),

            const Text(
              'Created at',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(request['createdAt']),

            // const Text(
            //   'Admin Notes',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(
            //   request['adminNotes']?.isNotEmpty == true
            //       ? request['adminNotes']
            //       : 'No notes from admin yet.',
            // ),
            const SizedBox(height: 16),

            if (request['imagePath'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attached Image',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(request['imagePath']),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
