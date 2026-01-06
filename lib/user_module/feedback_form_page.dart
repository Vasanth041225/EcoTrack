import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackFormPage extends StatefulWidget {
  final String reportId;
  final String volunteerId;

  const FeedbackFormPage({
    super.key,
    required this.reportId,
    required this.volunteerId,
  });

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _submitting = false;

  Future<void> _submitFeedback() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a comment')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance.collection('feedbacks').add({
        'reportId': widget.reportId,
        'citizenId': user.uid,
        'volunteerId': widget.volunteerId,
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Feedback'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Text(
              'Rate Volunteer Work',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    isDark ? Colors.green.shade300 : Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your feedback helps improve community services',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            // RATING CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // STAR RATING
                  Row(
                    children: List.generate(5, (index) {
                      final filled = index < _rating;
                      return IconButton(
                        iconSize: 34,
                        splashRadius: 22,
                        icon: Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: filled
                              ? Colors.amber
                              : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  // RATING LABEL
                  Text(
                    _rating == 5
                        ? 'Excellent'
                        : _rating == 4
                            ? 'Very Good'
                            : _rating == 3
                                ? 'Good'
                                : _rating == 2
                                    ? 'Fair'
                                    : 'Poor',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // COMMENT FIELD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  hintText: 'Share your experience with the volunteer...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.green.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submitting ? null : _submitFeedback,
                child: _submitting
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
