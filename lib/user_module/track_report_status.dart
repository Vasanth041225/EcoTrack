import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrackReportStatusPage extends StatefulWidget {
  const TrackReportStatusPage({super.key});

  @override
  State<TrackReportStatusPage> createState() => _TrackReportStatusPageState();
}

class _TrackReportStatusPageState extends State<TrackReportStatusPage> {
  String statusFilter = 'all';

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'assigned':
        return Colors.blue;
      case 'in_progress':
        return Colors.deepPurple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'assigned':
        return 'Assigned to Volunteer';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Track Report Status'),
        elevation: 0,
      ),
      body: Column(
        children: [
           
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: DropdownButtonFormField<String>(
              value: statusFilter,
              decoration: const InputDecoration(
                labelText: "Filter by Status",
                prefixIcon: Icon(Icons.filter_alt),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
              ],
              onChanged: (v) => setState(() => statusFilter = v!),
            ),
          ),

          // REPORT LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('citizenId', isEqualTo: user.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No reports submitted yet',
                        style: TextStyle(fontSize: 16)),
                  );
                }

                final reports = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data['status'] ?? 'pending';

                  if (status == 'completed') return false;

                  if (statusFilter != 'all' && status != statusFilter) {
                    return false;
                  }
                  return true;
                }).toList();

                if (reports.isEmpty) {
                  return const Center(child: Text("No reports match the filter"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final data =
                        reports[index].data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'pending';
                    final statusColor = _statusColor(status);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
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
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// STATUS HEADER
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.assignment,
                                      color: statusColor, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _statusText(status),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              statusColor.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // DESCRIPTION
                            Text(
                              data['description'] ?? '',
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),

                            const SizedBox(height: 10),

                    // CREATED TIME
                            if (data['createdAt'] != null)
                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Submitted on ${_formatDate(data['createdAt'])}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 18),

                            // VOLUNTEER INFO
                            if (data['volunteerId'] != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      statusColor.withOpacity(0.08),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Volunteer: ${data['volunteerName'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
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
    return '${date.day}/${date.month}/${date.year}  '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
