import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String citizenId;
  final String citizenName;
  final String description;
  final String location;
  final String status;
  final String? imageUrl;
  final String? volunteerId;
  final String? volunteerName;
  final String? completionImageUrl;
  final Timestamp createdAt;
  final Timestamp? completedAt;

  ReportModel({
    required this.id,
    required this.citizenId,
    required this.citizenName,
    required this.description,
    required this.location,
    required this.status,
    this.imageUrl,
    this.volunteerId,
    this.volunteerName,
    this.completionImageUrl,
    required this.createdAt,
    this.completedAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReportModel(
      id: doc.id,
      citizenId: data['citizenId'],
      citizenName: data['citizenName'],
      description: data['description'],
      location: data['location'],
      status: data['status'],
      imageUrl: data['imageUrl'],
      volunteerId: data['volunteerId'],
      volunteerName: data['volunteerName'],
      completionImageUrl: data['completionImageUrl'],
      createdAt: data['createdAt'],
      completedAt: data['completedAt'],
    );
  }
}
