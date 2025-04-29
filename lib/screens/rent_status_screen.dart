import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
 // Add this package

class RentStatusScreen extends StatefulWidget {
  const RentStatusScreen({super.key});

  @override
  State<RentStatusScreen> createState() => _RentStatusScreenState();
}

class _RentStatusScreenState extends State<RentStatusScreen> {
  late Future<Map<String, dynamic>> _rentStatusFuture;

  static const int garbageFee = 200;
  static const int otherCharges = 0;

  @override
  void initState() {
    super.initState();
    _rentStatusFuture = fetchRentStatus();
  }

  final _currencyFormat = NumberFormat.currency(locale: 'en_KE', symbol: 'KES', decimalDigits: 0);

  String formatCurrency(num amount) {
    return _currencyFormat.format(amount);
  }

  Future<Map<String, dynamic>> fetchRentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final tenantId = prefs.getString('tenantId');

    if (tenantId == null) {
      throw Exception('Tenant ID not found. Please login again');
    }

    final response = await http.get(
      Uri.parse('http://192.168.100.6:5000/api/rent/rent-status?tenantId=$tenantId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load rent status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Status'),
        actions: [
          IconButton(
            onPressed: () {
              // Help action
            },
            icon: const Icon(Icons.help_center),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _rentStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final rentStatus = data['rentStatus'] as List<dynamic>;
          final tenant = data['tenant'] as Map<String, dynamic>;

          if (rentStatus.isEmpty) {
            return const Center(child: Text('No rent status available'));
          }

          final latest = rentStatus.first;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _rentStatusFuture = fetchRentStatus();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Apartment Info',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      title: Text('Unit Number: ${tenant['unitNumber'] ?? 'N/A'}'),
                      subtitle: const Text('Rent Due: 5th of every month'),
                      trailing: const Icon(Icons.home),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Payment Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          _buildSummaryRow('Monthly Rent', formatCurrency(latest['rentAmount'] ?? 0)),
                          _buildSummaryRow('Water Bill', formatCurrency(latest['waterBill'] ?? 0)),
                          _buildSummaryRow('Garbage Fee', 'KES $garbageFee'),
                          _buildSummaryRow('Other Charges', 'KES $otherCharges'),
                          const Divider(),
                          _buildSummaryRow(
                            'Total Due',
                            formatCurrency((latest['rentAmount'] ?? 0) + (latest['waterBill'] ?? 0) + garbageFee + otherCharges),
                            isBold: true,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Due Date: ${_formatDate(latest['dueDate'])}'),
                              Chip(
                                label: Text(
                                  latest['status'] ?? 'Unpaid',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Payment History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...rentStatus.map((entry) {
                    const garbageFee = 200;
                    const otherCharges = 0;
                    return _buildPaymentTile(
                      entry['month'] ?? 'Unknown',
                        formatCurrency((entry['rentAmount'] ?? 0) + (entry['waterBill'] ?? 0) + garbageFee + otherCharges),
                      entry['status'] ?? 'Unpaid',
                      _formatDate(entry['paidDate']),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  const Text('Receipts / Proof of Payment',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.upload_file),
                      title: const Text('Upload receipt'),
                      onTap: () async {
                        // FilePickerResult? result =
                        // await FilePicker.platform.pickFiles();
                        // if (result != null) {
                        //   final file = result.files.first;
                        //   print('Selected: ${file.name}');
                          // Upload logic here
                        }
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Support action
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Contact admin'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(
      String month, String amount, String status, String datePaid) {
    Color statusColor = status == 'Paid'
        ? Colors.green
        : status == 'Unpaid'
        ? Colors.red
        : Colors.orange;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_month),
        title: Text(month),
        subtitle:
        Text('Amount: $amount\nDate Paid: ${datePaid.isNotEmpty ? datePaid : 'N/A'}'),
        trailing: Chip(
          label: Text(status, style: const TextStyle(color: Colors.white)),
          backgroundColor: statusColor,
        ),
        isThreeLine: true,
      ),
    );
  }

  static String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    DateTime dt = DateTime.tryParse(date) ?? DateTime.now();
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
