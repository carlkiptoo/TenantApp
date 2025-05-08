import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;


class MaintenanceRequestScreen extends StatefulWidget {
  const MaintenanceRequestScreen({super.key});

  @override
  State<MaintenanceRequestScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  File? _imageFile;

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

  Future<void> _submitRequest() async {
    debugPrint('🚀 _submitRequest called');

    if (!_formKey.currentState!.validate()) return;

    debugPrint('Form is valid');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final tenantId = prefs.getString('tenantId');

    if (token == null || tenantId == null) {
      debugPrint('Token or tenant Id is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to submit a request'))
      );
      return;
    }

    try {
      final uri = Uri.parse('http://192.168.100.6:5000/api/maintenance/maintenance-requests');
      debugPrint('This is the uri: $uri');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['tenantId'] = tenantId
        ..fields['description'] = _descriptionController.text
        ..fields['priority'] = priorityLabel
        ..fields['preferredDate'] = _dateController.text;
      debugPrint('📝 Description: ${_descriptionController.text}');
      debugPrint('📅 Date: ${_dateController.text}');
      debugPrint('🔧 Priority: $priorityLabel');
      debugPrint('🚚 Sending maintenance request ...$request');


      if (_imageFile != null) {
        debugPrint('Attaching image: ${_imageFile!.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          filename: path.basename(_imageFile!.path),
        ));
      }

      debugPrint('Sending maintenance request ...');

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      debugPrint('Streamed response ${streamedResponse.statusCode}');
      debugPrint('Response Body $responseBody');

      // if (streamedResponse.statusCode == 201) {
      //   debugPrint('Maintenance request submitted successful');
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Request submitted successfully'))
      //   );
      //   Navigator.pop(context);
      // } else {
      //   debugPrint('Error response: $responseBody');
      //   throw Exception('Failed to submit request');
      // }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Maintenance request submitted successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;
      setState(() {
        _descriptionController.clear();
        _dateController.clear();
        _imageFile = null;
        _priorityValue = 0;
      });

    } catch (error, stackTrace) {
      debugPrint('🔥 Exception occurred during submission: $error');
      debugPrint(stackTrace.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving request: $error'))
      );
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
              // Text(
              //   'Apartment Info (auto-filled from server',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 20),

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
                validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
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