import 'package:flutter/material.dart';

class RentStatusScreen extends StatelessWidget {
  const RentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Status'),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.help_center),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apartment Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                title: Text('Unit Number: A3'),
                subtitle: Text('Rent Due: 5th of every month'),
                trailing: Icon(Icons.home),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Monthly Rent', 'KES 25,000'),
                    _buildSummaryRow('Water Bill', 'KES 4,000'),
                    _buildSummaryRow('Garbage Fee', 'KES 200'),
                    _buildSummaryRow('Other Charges', 'KES 0'),

                    const Divider(),

                    _buildSummaryRow('Total Due', 'KES 29200',
                      isBold: true, color: Colors.red),
                    const SizedBox(height: 6),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Due Date: April 5, 2025'),
                        Chip(
                          label: Text(
                            'Overdue',
                            style: TextStyle(color: Colors.white)
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...[
              _buildPaymentTile('March 2025', 'KES 29,200', 'Paid', 'Mar 3 2025'),
              _buildPaymentTile('March 2025', 'KES 29,200', 'Paid', 'Feb 3 2025'),
              _buildPaymentTile('March 2025', 'KES 29,200', 'Paid', 'Unpaid'),
            ],

            const SizedBox(height: 20),

            const Text(
              'Receipts / Proof of Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload receipt'),
                onTap: () {
                  // IMPLEMENT FILE PICKER
                },
              ),
            ),

              const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Support dialog
                },
                icon: Icon(Icons.phone),
                label: Text('Contact admin'),
              ),
            )
          ],
        ),
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

  Widget _buildPaymentTile(String month, String amount, String status, String datePaid) {
    Color statusColor =
        status == 'Paid' ? Colors.green : status == 'Unpaid' ? Colors.red : Colors.orange;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_month),
        title: Text(month),
        subtitle: Text('Amount: $amount\nDate Paid: ${datePaid.isNotEmpty ? datePaid : 'N/A'}'),
        trailing: Chip(
          label: Text(status, style: const TextStyle(color: Colors.white)),
          backgroundColor: statusColor,
        ),
        isThreeLine: true,
      ),
    );
  }
}