import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'confirm_password_page.dart';
import 'home_page.dart';
import 'riwayat_page.dart';
import 'profile_page.dart';
import 'edit_profile_page.dart';
import 'input_data_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/confirm_password': (context) => const ConfirmPasswordPage(),
        '/home': (context) => const HomePage(),
        '/riwayat': (context) => const RiwayatPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/input_data': (context) => const InputDataPage(),
      },
    );
  }
}