import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class SubmitReportPage extends StatefulWidget {
  const SubmitReportPage({super.key});

  @override
  State<SubmitReportPage> createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionC = TextEditingController();
  final TextEditingController _locationNoteC = TextEditingController();

  String? _category;
  TimeOfDay? _time;
  DateTime? _date;


  File? _image;
  LatLng? _pickedLatLng;
  bool _submitting = false;

  final picker = ImagePicker();

  final List<String> _categories = [
    "Garbage Overflow",
    "Illegal Dumping",
    "Road Damage",
    "Drainage Issue",
    "Other",
  ];

  // ================= IMAGE =================
  Future<void> _pickImage() async {
    final img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (img != null) {
      setState(() => _image = File(img.path));
    }
  }

  // ================= TIME =================
  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _time = t);
  }

  // ================= DATE =================
Future<void> _pickDate() async {
  final d = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (d != null) setState(() => _date = d);
}


  // ================= LOCATION =================
  Future<void> _pickLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _pickedLatLng = LatLng(pos.latitude, pos.longitude);
    });
  }

  // ================= SUBMIT =================
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null ||
        _pickedLatLng == null ||
        _category == null ||
        _time == null ||
        _date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final String? imgUrl = null;

      await FirebaseFirestore.instance.collection("reports").add({
        "citizenId": user.uid,
        "citizenName": userDoc["name"],
        "category": _category,
        "description": _descriptionC.text.trim(),
        "locationNote": _locationNoteC.text.trim(),
        "time": "${_time!.hour}:${_time!.minute}",
        "date": Timestamp.fromDate(_date!),
        "lat": _pickedLatLng!.latitude,
        "lng": _pickedLatLng!.longitude,
        "imageUrl": imgUrl,
        "status": "pending",
        "volunteerId": null,
        "volunteerName": null,
        "completionImageUrl": null,
        "createdAt": Timestamp.now(),
        "completedAt": null,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report submitted successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Submit Cleanliness Report"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Report Details"),
              _card(
                Column(
                  children: [
                    _dropdown(),
                    const SizedBox(height: 16),
                    _timeField(),
                    const SizedBox(height: 16),
                    _dateField(), // ✅ NEW DATE FIELD
                    const SizedBox(height: 16),
                    _textField(
                        _locationNoteC, "Location Note", Icons.place_outlined),
                    const SizedBox(height: 16),
                    _descriptionField(),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _sectionHeader("Evidence"),
              _card(
                Column(
                  children: [
                    _imagePicker(),
                    const SizedBox(height: 16),
                    _locationPicker(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  onPressed: _submitting ? null : _submitReport,
                  label: _submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Report",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: child,
    );
  }

  Widget _textField(
      TextEditingController c, String label, IconData icon) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      controller: _descriptionC,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: "Description",
        prefixIcon: Icon(Icons.description_outlined),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      items: _categories
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => _category = v),
      decoration: const InputDecoration(
        labelText: "Category",
        prefixIcon: Icon(Icons.category_outlined),
      ),
      validator: (v) => v == null ? "Required" : null,
    );
  }

  Widget _timeField() {
    return GestureDetector(
      onTap: _pickTime,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText:
                _time == null ? "Select Time" : _time!.format(context),
            prefixIcon: const Icon(Icons.access_time),
          ),
          validator: (_) => _time == null ? "Required" : null,
        ),
      ),
    );
  }

  Widget _dateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: _date == null
                ? "Select Date"
                : "${_date!.day}/${_date!.month}/${_date!.year}",
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (_) => _date == null ? "Required" : null,
        ),
      ),
    );
  }


  Widget _imagePicker() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt, size: 36),
                  SizedBox(height: 8),
                  Text("Take Photo"),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _image!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _locationPicker() {
    return SizedBox(
      height: 220,
      child: _pickedLatLng == null
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text("Pick Location"),
                onPressed: _pickLocation,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _pickedLatLng!,
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("loc"),
                    position: _pickedLatLng!,
                  ),
                },
                onTap: (latLng) =>
                    setState(() => _pickedLatLng = latLng),
              ),
            ),
    );
  }
}
