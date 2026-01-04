import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final _reportRef = FirebaseFirestore.instance.collection('reports');

  Future<void> createReport({
    required String citizenId,
    required String citizenName,
    required String description,
    required String location,
    required String imageUrl,
  }) async {
    await _reportRef.add({
      'citizenId': citizenId,
      'citizenName': citizenName,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'status': 'pending',
      'volunteerId': null,
      'volunteerName': null,
      'completionImageUrl': null,
      'createdAt': Timestamp.now(),
      'completedAt': null,
    });
  }

  Future<void> assignReport({
    required String reportId,
    required String volunteerId,
    required String volunteerName,
  }) async {
    await _reportRef.doc(reportId).update({
      'status': 'assigned',
      'volunteerId': volunteerId,
      'volunteerName': volunteerName,
    });
  }

  Future<void> completeReport({
    required String reportId,
    required String completionImageUrl,
  }) async {
    await _reportRef.doc(reportId).update({
      'status': 'completed',
      'completionImageUrl': completionImageUrl,
      'completedAt': Timestamp.now(),
    });
  }
}
