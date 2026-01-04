import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VolunteerFeedbacksPage extends StatefulWidget {
  const VolunteerFeedbacksPage({super.key});

  @override
  State<VolunteerFeedbacksPage> createState() =>
      _VolunteerFeedbacksPageState();
}

class _VolunteerFeedbacksPageState extends State<VolunteerFeedbacksPage> {
  int selectedRating = 0; 

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Feedbacks'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ================= FILTER BY STAR  =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 18),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: selectedRating,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('All')),
                    DropdownMenuItem(value: 5, child: Text('5 Stars')),
                    DropdownMenuItem(value: 4, child: Text('4 Stars')),
                    DropdownMenuItem(value: 3, child: Text('3 Stars')),
                    DropdownMenuItem(value: 2, child: Text('2 Stars')),
                    DropdownMenuItem(value: 1, child: Text('1 Star')),
                  ],
                  onChanged: (v) {
                    setState(() => selectedRating = v!);
                  },
                ),
              ],
            ),
          ),

          // ================= FEEDBACK LIST =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feedbacks')
                  .where('volunteerId', isEqualTo: user.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No feedback received yet',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                //  FILTER LOGIC (NEW, SAFE)
                final feedbacks = snapshot.data!.docs.where((doc) {
                  final rating = doc['rating'] ?? 0;
                  if (selectedRating == 0) return true;
                  return rating == selectedRating;
                }).toList();

                if (feedbacks.isEmpty) {
                  return const Center(
                    child: Text('No feedback for this rating'),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final data = feedbacks[index].data()
                        as Map<String, dynamic>;
                    final rating = data['rating'] ?? 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // HEADER
                            Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.amber
                                        .withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.rate_review,
                                    color: Colors.amber,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '$rating / 5 Rating',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // STAR RATING
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),

                            const SizedBox(height: 12),

                            // COMMENT
                            Text(
                              data['comment'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // DATE
                            if (data['createdAt'] != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Received on: ${_formatDate(data['createdAt'])}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
