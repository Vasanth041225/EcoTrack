import 'package:flutter/material.dart';
import '../volunteer_module/available_reports.dart';
import '../volunteer_module/your_tasks.dart';
import '../volunteer_module/task_history.dart';
import '../volunteer_module/volunteer_feedbacks.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("EcoTrack Volunteer Dashboard"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== HEADER =====
            Text(
              "Ready to help? 💪",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.green.shade300 : Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Choose a task and make a difference today",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 26),

            // ===== ACTION CARDS =====
            _ActionCard(
              icon: Icons.assignment_outlined,
              label: "Available Reports",
              subtitle: "Pick a task to work on",
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade600],
              ),
              onTap: () => _nav(context, const AvailableReportsPage()),
            ),

            _ActionCard(
              icon: Icons.playlist_add_check,
              label: "Your Tasks",
              subtitle: "Tasks currently assigned to you",
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
              ),
              onTap: () => _nav(context, const YourTasksPage()),
            ),

            _ActionCard(
              icon: Icons.history,
              label: "Task History",
              subtitle: "View completed & past tasks",
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              onTap: () => _nav(context, const TaskHistoryPage()),
            ),

            _ActionCard(
              icon: Icons.feedback_outlined,
              label: "Volunteer Feedback",
              subtitle: "See what users say about your work",
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade700],
              ),
              onTap: () => _nav(context, const VolunteerFeedbacksPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _nav(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

// ===================================================================
// ACTION CARD (Enhanced UI)
// ===================================================================
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),

            const SizedBox(width: 16),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
