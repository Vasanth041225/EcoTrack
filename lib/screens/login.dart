import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'dashboard_admin.dart';
import 'register.dart';
import 'user_root_screen.dart';
import 'volunteer_root_screen.dart';
//import 'login.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthService _auth = AuthService();

  bool loading = false;
  bool showPassword = false;

  late AnimationController _anim;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );

    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  // -----------------------------
  // FORGOT PASSWORD POPUP
  // -----------------------------
  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController resetEmail = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your email and we will send a reset link."),
            const SizedBox(height: 10),
            TextField(
              controller: resetEmail,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Send"),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: resetEmail.text.trim(),
                );
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Reset link sent to your email")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black26,
        title: const Text("Login"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),

      body: FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Text(
                  "EcoTrack",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: isDark
                        ? Colors.green.shade300
                        : Colors.green.shade800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Login to continue",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.green.shade700,
                  ),
                ),

                const SizedBox(height: 30),

                // --- Glassmorphism Card ---
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.85),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // EMAIL FIELD
                      TextField(
                        controller: emailC,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_rounded,
                              color: Colors.green.shade700),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.green.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // PASSWORD FIELD
                      TextField(
                        controller: passC,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_rounded,
                              color: Colors.green.shade700),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green.shade700,
                            ),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.green.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child:
                              const Text("Forgot Password?", style: TextStyle(fontSize: 14)),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // LOGIN BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          minimumSize: const Size(double.infinity, 55),
                          elevation: 4,
                          shadowColor: Colors.green.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          if (emailC.text.isEmpty || passC.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Email and password required")),
                            );
                            return;
                          }

                          setState(() => loading = true);

                          var result = await _auth.login(
                            emailC.text.trim(),
                            passC.text.trim(),
                          );

                          setState(() => loading = false);

                          if (result is String) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)));
                            return;
                          }

                          if (result is UserModel) {
                          
                            //  BLOCK SUSPENDED USERS
                            if ((result.banned ?? false) == true) {

                              await FirebaseAuth.instance.signOut();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Your account has been suspended. Please contact the administrator.",
                                  ),
                                ),
                              );
                              return;
                            }

                          if (result.role == "admin") {
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminRootScreen(),
                                ),
                              );
                                  } else if (result.role == "citizen") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CitizenRootScreen(),
                                      ),
                                    );
                                  } else if (result.role == "volunteer") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const VolunteerRootScreen(),
                                      ),
                                    );
                                  } else {
                                    // Safety fallback (optional but recommended)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Unknown user role. Please contact admin."),
                                      ),
                                    );
                                  }
                                }

                        },
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Login",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // REGISTER
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






