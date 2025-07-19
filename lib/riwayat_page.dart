import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Riwayat Perawatan'),
        ),
        automaticallyImplyLeading: false, // Menghapus ikon kembali
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.history,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Perawatan Rutin'),
            subtitle: Text('2023-11-15'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.history,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Penggantian Filter'),
            subtitle: Text('2023-10-20'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.history,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Pemeriksaan Mesin'),
            subtitle: Text('2023-09-05'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.history,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Perbaikan Minor'),
            subtitle: Text('2023-08-10'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.history,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Pembersihan Mendalam'),
            subtitle: Text('2023-07-25'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: '',
          ),
        ],
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            // Navigasi ke HomePage dengan transisi halus
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionsBuilder: (_, animation, __, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          } else if (index == 1) {
            // Tetap di halaman ini (Riwayat)
          } else if (index == 2) {
            // Navigasi ke ProfilePage dengan transisi halus
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfilePage(),
                transitionsBuilder: (_, animation, __, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          }
        },
      ),
    );
  }
}