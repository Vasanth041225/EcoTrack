import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class TaskDetailsPage extends StatefulWidget {
  final String reportId;

  const TaskDetailsPage({super.key, required this.reportId});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController completionC = TextEditingController();
  File? completionImage;
  bool submitting = false;

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => completionImage = File(picked.path));
    }
  }

  Future<void> _completeTask() async {
    if (completionC.text.isEmpty || completionImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photo and description required")),
      );
      return;
    }

    setState(() => submitting = true);

    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .update({
      'status': 'completed',
      'completionNote': completionC.text.trim(),
      'completionImageUrl': null, // keep as null for now
      'completedAt': Timestamp.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task completed")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Details")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .doc(widget.reportId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Category: ${data['category']}"),
                const SizedBox(height: 6),

                Text("Description: ${data['description']}"),
                const SizedBox(height: 6),

                Text("Location Note: ${data['locationNote']}"),
                const SizedBox(height: 12),

                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(data['lat'], data['lng']),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("loc"),
                        position: LatLng(data['lat'], data['lng']),
                      ),
                    },
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: completionC,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Completion Description",
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Take Completion Photo"),
                  onPressed: _pickImage,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: submitting ? null : _completeTask,
                  child: const Text("Submit Completion"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
