import 'package:flutter/material.dart';
import 'package:jadwalperawatanmesin/db/db_helper.dart';
import 'package:jadwalperawatanmesin/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userIdController = TextEditingController();
  final jabatanController = TextEditingController();
  final passwordController = TextEditingController();

  String? fullNameError;
  String? emailError;
  String? userIdError;
  String? jabatanError;
  String? passwordError;
  bool _obscurePassword = true; // Kontrol visibilitas password

  // void validateAndSubmit() {
  //   setState(() {
  //     fullNameError = fullNameController.text.trim().isEmpty ? 'Full Name wajib diisi' : null;
  //     emailError = emailController.text.trim().isEmpty ? 'Email wajib diisi' : null;
  //     userIdError = userIdController.text.trim().isEmpty ? 'User ID wajib diisi' : null;
  //     jabatanError = jabatanController.text.trim().isEmpty ? 'Jabatan wajib diisi' : null;
  //     passwordError = passwordController.text.isEmpty ? 'Password wajib diisi' : null;
  //   });

  //   if (fullNameError == null &&
  //       emailError == null &&
  //       userIdError == null &&
  //       jabatanError == null &&
  //       passwordError == null) {
  //     Navigator.pop(context);
  //   }
  // }

void validateAndSubmit() async {
  setState(() {
    fullNameError = fullNameController.text.trim().isEmpty ? 'Full Name wajib diisi' : null;
    emailError = emailController.text.trim().isEmpty ? 'Email wajib diisi' : null;
    // userIdError = userIdController.text.trim().isEmpty ? 'User ID wajib diisi' : null;
    jabatanError = jabatanController.text.trim().isEmpty ? 'Jabatan wajib diisi' : null;
    passwordError = passwordController.text.isEmpty ? 'Password wajib diisi' : null;
  });

  if (fullNameError == null &&
      emailError == null &&
      // userIdError == null &&
      jabatanError == null &&
      passwordError == null) {

    // ✅ Panggil method registerUser
    int userId = await DBHelper.registerUser(
      fullNameController.text.trim(),
      emailController.text.trim(),
      jabatanController.text.trim(),
      passwordController.text,
    );

    final user = await DBHelper.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

      if (user != null) {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      }

    print('User berhasil ditambahkan dengan id: $userId');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    filled: true,
                    fillColor: Colors.white70,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: fullNameError,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    filled: true,
                    fillColor: Colors.white70,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: emailError,
                  ),
                ),
                // const SizedBox(height: 16),
                // TextField(
                //   controller: userIdController,
                //   decoration: InputDecoration(
                //     hintText: 'User ID',
                //     filled: true,
                //     fillColor: Colors.white70,
                //     contentPadding:
                //         const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //       borderSide: BorderSide.none,
                //     ),
                //     errorText: userIdError,
                //   ),
                // ),
                const SizedBox(height: 16),
                TextField(
                  controller: jabatanController,
                  decoration: InputDecoration(
                    hintText: 'Jabatan',
                    filled: true,
                    fillColor: Colors.white70,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: jabatanError,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword, // Kontrol visibilitas
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white70,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('SIGN UP'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(color: Colors.brown),
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