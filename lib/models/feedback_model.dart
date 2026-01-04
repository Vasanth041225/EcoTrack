import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String reportId;
  final String citizenId;
  final String volunteerId;
  final int rating;
  final String comment;
  final Timestamp createdAt;

  FeedbackModel({
    required this.id,
    required this.reportId,
    required this.citizenId,
    required this.volunteerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
