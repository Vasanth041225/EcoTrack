import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportHistoryPage extends StatefulWidget {
  const ReportHistoryPage({super.key});

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  DateTime? selectedDate;

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    return 'Completed';
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  bool _sameDate(Timestamp ts) {
    final d = ts.toDate();
    return d.year == selectedDate!.year &&
        d.month == selectedDate!.month &&
        d.day == selectedDate!.day;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Report History'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ===== DATE FILTER =====
          InkWell(
            onTap: () => _pickDate(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    selectedDate == null
                        ? "Filter by Date: All"
                        : "Filter by Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  if (selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => selectedDate = null),
                    )
                ],
              ),
            ),
          ),

          // ===== REPORT LIST =====
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('citizenId', isEqualTo: user.uid)
                  .where('status', isEqualTo: 'completed')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No completed reports',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final reports = snapshot.data!.docs.where((doc) {
                  if (selectedDate == null) return true;
                  return doc['completedAt'] != null &&
                      _sameDate(doc['completedAt']);
                }).toList();

                if (reports.isEmpty) {
                  return const Center(child: Text("No reports for this date"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final data =
                        reports[index].data() as Map<String, dynamic>;
                    final status = data['status'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// HEADER
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.assignment,
                                        size: 20,
                                        color: _statusColor(status)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _statusLabel(status),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _statusColor(status),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _statusColor(status)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _statusColor(status),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // DESCRIPTION
                            Text(
                              data['description'] ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // SUBMITTED TIME
                            Row(
                              children: [
                                const Icon(Icons.schedule,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  'Submitted: ${_formatDate(data['createdAt'])}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 20),

                            // VOLUNTEER INFO
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Volunteer Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 16, color: Colors.green),
                                    const SizedBox(width: 6),
                                    Text(
                                      data['volunteerName'] ??
                                          'Unknown Volunteer',
                                      style:
                                          const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                           // ===== COMPLETION IMAGE =====
                            if (data['completionImageUrl'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GestureDetector(
                                  onTap: () => _showFullImage(
                                    context,
                                    data['completionImageUrl'],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      data['completionImageUrl'],
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



                            // COMPLETED TIME
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Completed on: ${_formatDate(data['completedAt'])}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

      void _showFullImage(BuildContext context, String imageUrl) {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      }
}

