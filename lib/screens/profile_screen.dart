import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  final TextEditingController phoneController = TextEditingController(text: '0745678987');
  final TextEditingController emailController = TextEditingController(text: 'tenant@tenant.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });

              if (!isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact info saved')),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            _buildInfoTile("Full Name", "John Doe"),
            _buildInfoTile("National ID", "12345678"),
            _buildInfoTile("Apartment Name", "Sunrise Villas"),
            _buildInfoTile("House Number", "A-204"),
            _buildEditableTile("Phone Number", phoneController),
            _buildEditableTile("Email", emailController),
            const Divider(height: 32),
            _buildInfoTile("Account Created", "2024-01-15"),
            _buildInfoTile("Last Updated", "2024-12-10"),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                //LOg out logic
                Navigator.pushReplacement(context, '/login' as Route<Object?>);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      dense: true,
    );
  }

  Widget _buildEditableTile(String title, TextEditingController controller) {
    return ListTile(
      title: Text(title),
      subtitle: isEditing ? TextField(
        controller: controller,
        decoration: const InputDecoration(border: UnderlineInputBorder()),
      ) : Text(controller.text),
    );
  }
}