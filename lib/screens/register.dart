import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  String role = "citizen";
  bool showPassword = false;
  bool loading = false;

  final AuthService _auth = AuthService();

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

bool isStrongPassword(String password) {
  final hasUppercase = password.contains(RegExp(r'[A-Z]'));
  final hasLowercase = password.contains(RegExp(r'[a-z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecialChar =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  final hasMinLength = password.length >= 8;

  return hasUppercase &&
      hasLowercase &&
      hasDigit &&
      hasSpecialChar &&
      hasMinLength;
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black26,
        centerTitle: true,
        title: const Text("Create Account"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
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
                // Title
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
                  "Create a new account",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: isDark
                        ? Colors.grey.shade300
                        : Colors.green.shade700,
                  ),
                ),

                const SizedBox(height: 30),

                // Glassmorphism Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.90),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // Email Field
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

                      // Password Field
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
                      const SizedBox(height: 18),

                      // Role Dropdown
                      DropdownButtonFormField(
                        value: role,
                        decoration: InputDecoration(
                          labelText: "Select Role",
                          prefixIcon: Icon(Icons.person_rounded,
                              color: Colors.green.shade700),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.green.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "citizen", child: Text("Citizen")),
                          DropdownMenuItem(
                              value: "volunteer", child: Text("Volunteer")),
                         // DropdownMenuItem(value: "admin", child: Text("Admin")),
                        ],
                        onChanged: (v) => setState(() => role = v!),
                      ),

                      const SizedBox(height: 25),

                      // Register Button
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
                              const SnackBar(content: Text("Email and Password required")),
                            );
                            return;
                          }

                          if (!isStrongPassword(passC.text.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Password must be at least 8 characters and include:\n"
                                  "• Uppercase letter\n"
                                  "• Lowercase letter\n"
                                  "• Number\n"
                                  "• Special character",
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() => loading = true);

                          var result = await _auth.register(
                            emailC.text.trim(),
                            passC.text.trim(),
                            role,
                          );

                          setState(() => loading = false);

                          if (result == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Account created successfully!")),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                          }
                        },
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Create Account",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ],
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





