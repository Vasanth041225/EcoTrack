import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../services/auth_service.dart';
import 'login.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final picker = ImagePicker();

  Future<void> _openEditDialog(Map<String, dynamic> userData, String uid) async {
    final nameC = TextEditingController(text: userData["name"] ?? "");
    final phoneC = TextEditingController(text: userData["phone"] ?? "");

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneC,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              child: const Text("Save"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("users").doc(uid).update({
                  "name": nameC.text.trim(),
                  "phone": phoneC.text.trim(),
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile updated")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // -------------------------------
  // Upload profile picture
  // -------------------------------
  Future<void> _pickImage(String uid) async {
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img == null) return;

    File file = File(img.path);

    final ref = FirebaseStorage.instance.ref().child("profilePics/$uid.jpg");

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "profilePic": url,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile picture updated")),
    );

    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (user != null)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.data() == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  String email = data["email"] ?? user.email ?? "Unknown";
                  String role = data["role"] ?? "Unknown";
                  String name = data["name"] ?? "No name added";
                  String phone = data["phone"] ?? "No phone added";
                  String? imageUrl = data["profilePic"];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Profile Picture
                          GestureDetector(
                            onTap: () => _pickImage(user.uid),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.green.shade700,
                              backgroundImage:
                                  imageUrl != null ? NetworkImage(imageUrl) : null,
                              child: imageUrl == null
                                  ? const Icon(Icons.camera_alt, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),

                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(email,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                                Text("Role: $role"),
                                Text("Name: $name"),
                                Text("Phone: $phone"),
                              ],
                            ),
                          ),

                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _openEditDialog(data, user.uid),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            // DARK MODE SWITCH
            SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Enable dark theme"),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
              secondary: const Icon(Icons.dark_mode),
            ),

            const Divider(height: 30),

            // ABOUT
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About EcoTrack"),
              subtitle: const Text("Version 1.0.0 • Environmental reporting"),
              onTap: () {},
            ),

            // PRIVACY
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Privacy & Terms"),
              subtitle: const Text("View data usage and policies"),
              onTap: () {},
            ),

            // HELP
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help & Support"),
              subtitle: const Text("Contact support or view FAQ"),
              onTap: () {},
            ),

            const Divider(height: 30),

            // LOGOUT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await AuthService().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




