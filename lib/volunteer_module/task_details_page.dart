import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  try {
    // 1️⃣ Upload image to Firebase Storage
    final fileName =
        "completion_${widget.reportId}_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = FirebaseStorage.instance
        .ref()
        .child("completion_images")
        .child(fileName);

    await ref.putFile(completionImage!);

    // 2️⃣ Get image URL
    final imageUrl = await ref.getDownloadURL();

    // 3️⃣ Update Firestore with image URL
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .update({
      'status': 'completed',
      'completionNote': completionC.text.trim(),
      'completionImageUrl': imageUrl, // ✅ NOW NOT NULL
      'completedAt': Timestamp.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task completed")),
      );
      Navigator.pop(context);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => submitting = false);
  }
}

      void _openFullImage(BuildContext context, String imageUrl) {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
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

                // ===== ORIGINAL REPORT IMAGE =====
                        if (data['imageUrl'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () => _openFullImage(context, data['imageUrl']),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  data['imageUrl'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return SizedBox(
                                      height: 180,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 180,
                                    alignment: Alignment.center,
                                    child: const Text("Unable to load image"),
                                  ),
                                ),
                              ),
                            ),
                          ),


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
