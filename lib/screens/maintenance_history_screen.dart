import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'request_detail_screen.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  List<dynamic> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceRequests();
  }

  Future<void> _fetchMaintenanceRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      debugPrint('Token: $token');
      final tenantId = prefs.getString('tenantId');

      if (token == null || tenantId == null) {
        setState(() {
          _errorMessage = 'Missing Authentication';
          _isLoading = false;
        });
        return;
      }

      final uri = Uri.parse('http://192.168.100.6:5000/api/maintenance/maintenance-requests');

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      });

      if (response.statusCode == 200) {
        debugPrint('Response body: ${response.body}');

        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final List<dynamic> data = responseData['requests'] ?? [];
        setState(() {
          _requests = data;
          _isLoading = false;

        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data ${response.statusCode}';
          _isLoading = false;
        });
      }

      if (response.statusCode == 401 && response.body.contains('jwt expired')) {
        setState(() {
          _errorMessage = 'Session expired. Please log in again';
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const LoginScreen()
          ),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error has occurred $error';
        _isLoading = false;
      });
    }
  }

  Color getStatusColor(String? status) {
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

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    } catch (error) {
      return "Invalid date";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _requests.isEmpty
              ? const Center(child: Text('No maintenance history available'))
                : RefreshIndicator(
                onRefresh: _fetchMaintenanceRequests,
              child: ListView.builder(
                itemCount: _requests.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final request = _requests[index];
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
                        backgroundColor: getStatusColor(request['status'] as String?),
                        child: Icon(Icons.build, color: Colors.white),
                      ),
                      title: Text(request['description']?.toString() ?? 'No description'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${request['status']?.toString() ?? 'Unknown'}'),
                          Text('Priority: ${request['priority'] ?? 'Unknown'}'),
                          Text('Preferred date: ${request['preferredDate'] != null ? _formatDate(request['preferredDate']) : 'Unknown'}'),
                          Text('Created: ${request['createdAt'] != null ? _formatDate(request['createdAt']) : 'Unknown'}')
                          // if (request['adminNotes'] != null &&
                          //     request['adminNotes'] is String &&
                          //     request['adminNotes'].toString().isNotEmpty)
                          //   Text('Notes: ${request['adminNotes']?.toString() ?? ''}'),
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
      ),
    );
  }
}
