import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:vas_flutter/screens/chat_screen.dart';
import 'package:fl_chart/fl_chart.dart';


// =======================
// ADMIN ROOT 
// =======================
class AdminRootScreen extends StatefulWidget {
  const AdminRootScreen({super.key});

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    AdminDashboard(),
    ChatScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor:
            theme.brightness == Brightness.dark ? Colors.white60 : Colors.grey,
        backgroundColor:
            theme.brightness == Brightness.dark ? const Color(0xFF222222) : Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

// =======================
// ADMIN DASHBOARD 
// =======================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoTrack Admin Dashboard"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Control Center 👑",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.green.shade300 : Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 20),

            // ================= USERS + REPORTS =================
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Users",
                    stream: FirebaseFirestore.instance.collection("users").snapshots(),
                    icon: Icons.people,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade700],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UsersListScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: "Reports",
                    stream: FirebaseFirestore.instance.collection("reports").snapshots(),
                    icon: Icons.report,
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade700],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReportsManagementScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    label: "System Insights",
                    icon: Icons.analytics,
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SystemInsightsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    label: "Critical Reports",
                    icon: Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CriticalReportsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),


            const SizedBox(height: 20),

            Text(
              "Smart Admin Tools",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _AdminActionCard(
              icon: Icons.analytics,
              title: "System Insights",
              description:
                  "Live statistics on reports, volunteers & system health",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SystemInsightsScreen()),
                );
              },
            ),

            _AdminActionCard(
              icon: Icons.warning_amber_rounded,
              title: "Critical Reports Monitor",
              description:
                  "Detect old, unassigned or delayed reports instantly",
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CriticalReportsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SystemInsightsScreen extends StatelessWidget {
  const SystemInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("System Insights")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("reports").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          int pending = 0,
              assigned = 0,
              inProgress = 0,
              completed = 0;

          for (var d in docs) {
            final s = d["status"];
            if (s == "pending") pending++;
            if (s == "assigned") assigned++;
            if (s == "in_progress") inProgress++;
            if (s == "completed") completed++;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ===== TITLE =====
                const Text(
                  "Reports Overview",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // ===== BAR GRAPH =====
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text("Pending");
                                case 1:
                                  return const Text("Assigned");
                                case 2:
                                  return const Text("Progress");
                                case 3:
                                  return const Text("Completed");
                                default:
                                  return const Text("");
                              }
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(toY: pending.toDouble(), color: Colors.orange),
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(toY: assigned.toDouble(), color: Colors.indigo),
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(toY: inProgress.toDouble(), color: Colors.deepPurple),
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(toY: completed.toDouble(), color: Colors.green),
                        ]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =====  CARDS  =====
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _InsightCard("Total Reports", docs.length, Colors.blue),
                    _InsightCard("Pending", pending, Colors.orange),
                    _InsightCard("Assigned", assigned, Colors.indigo),
                    _InsightCard("In Progress", inProgress, Colors.deepPurple),
                    _InsightCard("Completed", completed, Colors.green),
                  ],
                ),
              ],
            ),
          );

        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _InsightCard(this.title, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CriticalReportsScreen extends StatelessWidget {
  const CriticalReportsScreen({super.key});

  bool _isCritical(Map<String, dynamic> data) {
    if (data["createdAt"] == null) return false;
    if (data["status"] == "completed") return false;

    final created = (data["createdAt"] as Timestamp).toDate();
    return DateTime.now().difference(created).inHours > 24;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Critical Reports")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("reports")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final critical = snapshot.data!.docs.where((d) {
            return _isCritical(d.data() as Map<String, dynamic>);
          }).toList();

          if (critical.isEmpty) {
            return const Center(
              child: Text("No critical reports 🎉"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: critical.length,
            itemBuilder: (context, index) {
              final doc = critical[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(
                    data["description"] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "Status: ${data["status"]}",
                    style: const TextStyle(color: Colors.red),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ReportDetailsDialog(
                        reportId: doc.id,
                        data: data,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot> stream;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.stream,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        final count = snap.hasData ? snap.data!.size : 0;

        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// =======================
// DASHBOARD TILE
// =======================
class _DashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final Stream<QuerySnapshot> stream;

  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snap) {
        final count = snap.hasData ? snap.data!.size : 0;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 34),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =======================
// ADMIN ACTION CARD
// =======================
class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}


// -----------------------------------------
// USERS MANAGEMENT (client-side filter & search)
// - search, filter, change role, ban/unban, delete
// - writes audit log on actions
// -----------------------------------------
class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String search = "";
  String roleFilter = "all";

  Stream<QuerySnapshot> usersStream() {
    // always fetch all users and filter client-side (F2)
    return FirebaseFirestore.instance.collection("users").orderBy("createdAt", descending: true).snapshots();
  }

  void _audit(String action, Map<String, dynamic> details) {
    FirebaseFirestore.instance.collection("audit_logs").add({
      "action": action,
      "details": details,
      "admin": "admin", // replace with current admin email/uid if available
      "timestamp": Timestamp.now(),
    });
  }

  Future<void> _changeRole(String userId, String newRole) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({"role": newRole});
    _audit("change_role", {"userId": userId, "newRole": newRole});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Role changed to $newRole")));
  }

  Future<void> _deleteUser(String userId, String email) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).delete();
    _audit("delete_user", {"userId": userId, "email": email});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User deleted")));
  }

  Future<void> _toggleBan(String userId, bool currentlyBanned) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({"banned": !currentlyBanned});
    _audit("toggle_ban", {"userId": userId, "banned": !currentlyBanned});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(!currentlyBanned ? "User suspended" : "User unsuspended")));
  }

  void _openActions(Map<String, dynamic> data, String docId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) {
        final bool isBanned = (data['banned'] ?? false) as bool;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(data['email'] ?? "No email"),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text("Change Role"),
              onTap: () {
                Navigator.pop(context);
                _showRoleDialog(docId, data);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: Text(isBanned ? "Un-suspend User" : "Suspend User"),
              onTap: () {
                Navigator.pop(context);
                _toggleBan(docId, isBanned);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Delete User", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(docId, data['email'] ?? "");
              },
            ),
            const Divider(),
            ListTile(leading: const Icon(Icons.close), title: const Text("Cancel"), onTap: () => Navigator.pop(context)),
          ]),
        );
      },
    );
  }

  void _showRoleDialog(String userId, Map<String, dynamic> data) {
    String current = data['role'] ?? "citizen";
    showDialog(
      context: context,
      builder: (context) {
        String selected = current;
        return AlertDialog(
          title: const Text("Change Role"),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              RadioListTile<String>(value: "citizen", groupValue: selected, title: const Text("User"), onChanged: (v) => setState(() => selected = v!)),
              RadioListTile<String>(value: "volunteer", groupValue: selected, title: const Text("Volunteer"), onChanged: (v) => setState(() => selected = v!)),
              RadioListTile<String>(value: "admin", groupValue: selected, title: const Text("Admin"), onChanged: (v) => setState(() => selected = v!)),
            ]);
          }),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _changeRole(userId, selected);
                },
                child: const Text("Save"))
          ],
        );
      },
    );
  }

  void _confirmDelete(String userId, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Delete $email? This removes the user's Firestore profile (not Auth)."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(userId, email);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search email..."),
            onChanged: (v) => setState(() => search = v.trim().toLowerCase()),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: roleFilter,
          items: const [
            DropdownMenuItem(value: "all", child: Text("All")),
            DropdownMenuItem(value: "citizen", child: Text("User")),
            DropdownMenuItem(value: "volunteer", child: Text("Volunteer")),
            DropdownMenuItem(value: "admin", child: Text("Admin")),
          ],
          onChanged: (v) => setState(() => roleFilter = v ?? "all"),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users Management")),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersStream(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());

                // apply client-side filtering (F2)
                final allDocs = snap.data!.docs;
                final filtered = allDocs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final email = (data['email'] ?? "").toString().toLowerCase();
                  final role = (data['role'] ?? "").toString().toLowerCase();

                  if (search.isNotEmpty && !email.contains(search)) return false;
                  if (roleFilter != "all" && role != roleFilter) return false;
                  return true;
                }).toList();

                if (filtered.isEmpty) return const Center(child: Text("No users found"));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final doc = filtered[i];
                    final data = doc.data() as Map<String, dynamic>;
                    final bool banned = (data['banned'] ?? false) as bool;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.green.shade100, child: const Icon(Icons.person, color: Colors.green)),
                        title: Text(data['email'] ?? "No email"),
                        subtitle: Text("Role: ${data['role'] ?? 'citizen'}"),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (banned)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.block, color: Colors.orange),
                            ),
                          IconButton(icon: const Icon(Icons.more_vert), onPressed: () => _openActions(data, doc.id)),
                        ]),
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
}

// REPORTS MANAGEMENT 
// - list, filter by status, details, assign volunteer, resolve
// - accessible via Dashboard tile only
// =======================================
// REPORTS MANAGEMENT — ADMIN 
// =======================================
class ReportsManagementScreen extends StatefulWidget {
  const ReportsManagementScreen({super.key});

  @override
  State<ReportsManagementScreen> createState() =>
      _ReportsManagementScreenState();
}

class _ReportsManagementScreenState extends State<ReportsManagementScreen> {
  String statusFilter = "all";

  Stream<QuerySnapshot> _reportsStream() {
    Query q = FirebaseFirestore.instance
        .collection("reports")
        .orderBy("createdAt", descending: true);

    if (statusFilter != "all") {
      q = q.where("status", isEqualTo: statusFilter);
    }
    return q.snapshots();
  }

  Future<List<Map<String, dynamic>>> _fetchVolunteers() async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "volunteer")
        .get();

    return snap.docs
        .map((d) => {
              "id": d.id,
              "name": d["name"] ?? d["email"],
            })
        .toList();
  }

  Future<void> _assignVolunteer(
    String reportId,
    String volunteerId,
    String volunteerName,
  ) async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(reportId)
        .update({
      "volunteerId": volunteerId,
      "volunteerName": volunteerName,
      "status": "assigned",
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Volunteer assigned")),
    );
  }

  Future<void> _markCompleted(String reportId) async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(reportId)
        .update({
      "status": "completed",
      "completedAt": Timestamp.now(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report marked completed")),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case "pending":
        return Colors.orange;
      case "assigned":
        return Colors.blue;
      case "in_progress":
        return Colors.deepPurple;
      case "completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports Management"),
      ),
      body: Column(
        children: [
          /// FILTER BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text("Status:"),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: statusFilter,
                  items: const [
                    DropdownMenuItem(value: "all", child: Text("All")),
                    DropdownMenuItem(value: "pending", child: Text("Pending")),
                    DropdownMenuItem(value: "assigned", child: Text("Assigned")),
                    DropdownMenuItem(
                        value: "in_progress", child: Text("In Progress")),
                    DropdownMenuItem(
                        value: "completed", child: Text("Completed")),
                  ],
                  onChanged: (v) =>
                      setState(() => statusFilter = v ?? "all"),
                ),
              ],
            ),
          ),

          // REPORTS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _reportsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data!.docs;
                if (reports.isEmpty) {
                  return const Center(child: Text("No reports found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final doc = reports[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data["status"] ?? "pending";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _statusColor(status).withOpacity(0.15),
                          child: Icon(Icons.report,
                              color: _statusColor(status)),
                        ),
                        title: Text(
                          data["description"] ?? "No description",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "Citizen: ${data["citizenName"] ?? "Unknown"}",
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (v == "view") {
                              showDialog(
                                context: context,
                                builder: (_) => ReportDetailsDialog(
                                  reportId: doc.id,
                                  data: data,
                                ),
                              );
                            }

                            if (v == "assign") {
                              final volunteers = await _fetchVolunteers();
                              if (!mounted || volunteers.isEmpty) return;

                              showModalBottomSheet(
                                context: context,
                                builder: (_) => ListView(
                                  shrinkWrap: true,
                                  children: volunteers.map((v) {
                                    return ListTile(
                                      leading:
                                          const Icon(Icons.person_outline),
                                      title: Text(v["name"]),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _assignVolunteer(
                                          doc.id,
                                          v["id"],
                                          v["name"],
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            }

                            if (v == "complete" &&
                                status != "completed") {
                              _markCompleted(doc.id);
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: "view",
                              child: ListTile(
                                leading: Icon(Icons.visibility),
                                title: Text("View Details"),
                              ),
                            ),
                            const PopupMenuItem(
                              value: "assign",
                              child: ListTile(
                                leading: Icon(Icons.person_add),
                                title: Text("Assign Volunteer"),
                              ),
                            ),
                            PopupMenuItem(
                              value: "complete",
                              enabled: status != "completed",
                              child: const ListTile(
                                leading: Icon(Icons.check_circle,
                                    color: Colors.green),
                                title: Text("Mark Completed"),
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
}

// =======================================
// REPORT DETAILS DIALOG — FULL DETAILS
// =======================================
class ReportDetailsDialog extends StatelessWidget {
  final String reportId;
  final Map<String, dynamic> data;

  const ReportDetailsDialog({
    super.key,
    required this.reportId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = data["createdAt"] is Timestamp
        ? (data["createdAt"] as Timestamp).toDate()
        : null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Report Details",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _detail("Category", data["category"]),
            _detail("Status", data["status"]),
            _detail("User", data["citizenName"]),
            _detail("Volunteer", data["volunteerName"]),
            _detail("Location Note", data["locationNote"]),
            _detail("Time", data["time"]),

            if (createdAt != null)
              _detail("Submitted",
                  createdAt.toString().substring(0, 16)),

            const SizedBox(height: 12),

            Text(
              data["description"] ?? "",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 16),

            if (data["imageUrl"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  data["imageUrl"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$label: $value",
          style: const TextStyle(fontSize: 13)),
    );
  }
}


// -----------------------------------------
// Simple placeholder screen widget
// -----------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title (coming soon)", style: theme.textTheme.titleMedium)),
    );
  }
}




