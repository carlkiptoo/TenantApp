import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MaintenanceRequestScreen extends StatefulWidget {
  const MaintenanceRequestScreen({super.key});

  @override
  State<MaintenanceRequestScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String priority = 'Medium';
  File? _imageFile;

  //Simulated apt info
  final String unitNumber = 'A3';
  final String tenantName = 'Carl Kirui';
  final String description = '';

  double _priorityValue = 0;

  String get priorityLabel {
    switch (_priorityValue.toInt()) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Low';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      initialDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'unitNumber': unitNumber,
        'tenantName': tenantName,
        'description': description,
        'priority': priority,
        'preferredDate': _dateController.text,
        'imagePath': _imageFile?.path,
        'status': 'Pending',
        'dateReported': DateTime.now().toIso8601String(),
      };

      print('Submitted Request: $requestData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance request submitted')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit maintenance request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Unit Number: $unitNumber',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Tenant: $tenantName'),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Describe the issue',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                value == null || value.isEmpty
                    ? 'Please describe the issue'
                    : null,
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority: $priorityLabel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.green),
                          Text('Low', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.remove, color: Colors.orange),
                          Text('Medium', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.red),
                          Text('High', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: _priorityValue,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    label: priorityLabel,
                    activeColor:
                    _priorityValue == 0
                        ? Colors.green
                        : _priorityValue == 1
                        ? Colors.orange
                        : Colors.red,
                    onChanged: (newValue) {
                      setState(() {
                        _priorityValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Preferred Date for Repair',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Attach Image'),
                onPressed: _pickImage,
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(_imageFile!, height: 150),
                ),
              const SizedBox(height: 30),

              ElevatedButton(onPressed: _submitRequest, child: const Text('Submit Request')),
            ],
          ),
        ),
      ),
    );
  }
}