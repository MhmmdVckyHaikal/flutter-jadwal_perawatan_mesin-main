import 'package:flutter/material.dart';
import 'riwayat_page.dart';
import 'profile_page.dart';
import 'input_data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showInputModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const InputDataPage(),
    ).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Machine Maintenance'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showInputModal,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Machine 1'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Machine 2'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Machine 3'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Machine 4'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text('Machine 5'),
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
            // Home (tidak perlu navigasi)
          } else if (index == 1) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const RiwayatPage(),
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
          } else if (index == 2) {
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