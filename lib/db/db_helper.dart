import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDb() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'jadwal_perawatan.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create users table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT,
            position TEXT,
            password TEXT
          )
        ''');

        // Create machine table
        await db.execute('''
          CREATE TABLE machine (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            machine_name TEXT
          )
        ''');

        // Create maintenance_schedule table
        await db.execute('''
          CREATE TABLE maintenance_schedule (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            machine_id INTEGER,
            last_maintenance TEXT,
            interval INTEGER,
            expired_maintenance TEXT,
            FOREIGN KEY (machine_id) REFERENCES machine(id)
          )
        ''');

        // Create maintenance_history table
        await db.execute('''
          CREATE TABLE maintenance_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            machine_id INTEGER,
            maintenance_name TEXT,
            maintenance_date TEXT,
            FOREIGN KEY (machine_id) REFERENCES machine(id)
          )
        ''');

        // Insert debug user (admin / admin)
        await db.insert('users', {
          'nama': 'Admin',
          'email': 'admin@gmail.com',
          'position': 'Administrator',
          'password': 'admin', // kamu bisa hash jika pakai hash
        });
      },
    );

    return _db!;
  }

  // Register user
static Future<int> registerUser(String nama, String email, String position, String password) async {
  final db = await initDb();
  return await db.insert('users', {
    'nama': nama,
    'email': email,
    'position': position,
    'password': password,
  });
}

// Login user
static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  final db = await initDb();
  final result = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );
  return result.isNotEmpty ? result.first : null;
}

// Check Auth
Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('user_id');
}

// 🔄 Update password berdasarkan user ID dari SharedPreferences
  static Future<int> updatePasswordById(String newPassword) async {
    final db = await initDb();

    // Ambil user_id dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      return 0; // Gagal, user belum login
    }

    return await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }


// Logout (Handled in UI, just clear user session/token)
static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
}

// Get all machines
static Future<List<Map<String, dynamic>>> getAllMachines() async {
  final db = await initDb();
  return await db.query('machine');
}

// Tambah mesin baru
static Future<int> insertMachine(String machineName, int interval) async {
  final db = await initDb();
  return await db.insert('machine', {
    'machine_name': machineName,
    'interval': interval,
  });
}

// Tambah riwayat mesin
static Future<int> insertMaintenanceHistory(int machineId, String name, String date) async {
  final db = await initDb();
  return await db.insert('maintenance_history', {
    'machine_id': machineId,
    'maintenance_name': name,
    'maintenance_date': date,
  });
}

// Get all riwayat mesin
static Future<List<Map<String, dynamic>>> getAllHistory() async {
  final db = await initDb();
  return await db.rawQuery('''
    SELECT mh.id, m.machine_name, mh.maintenance_name, mh.maintenance_date
    FROM maintenance_history mh
    JOIN machine m ON mh.machine_id = m.id
    ORDER BY mh.maintenance_date DESC
  ''');
}

// Get riwayat mesin by machine ID
static Future<List<Map<String, dynamic>>> getHistoryByMachineId(int machineId) async {
  final db = await initDb();
  return await db.rawQuery('''
    SELECT * FROM maintenance_history
    WHERE machine_id = ?
    ORDER BY maintenance_date DESC
  ''', [machineId]);
}

// Get user by ID
static Future<Map<String, String>?> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final nama = prefs.getString('nama');

  if (email != null && nama != null) {
    return {
      'email': email,
      'nama': nama,
    };
  }
  return null;
}


// Update user data
static Future<int> updateUser(int id, Map<String, dynamic> data) async {
  final db = await initDb();
  return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
}

// GetData Profile 
static Future<Map<String, dynamic>?> getUserProfile() async {
  final db = await initDb();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');

  if (userId == null) return null;

  List<Map<String, dynamic>> result = await db.query(
    'users',
    where: 'id = ?',
    whereArgs: [userId],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first;
  } else {
    return null;
  }
}

// Update DataProfile
static Future<int> updateUserProfile(String nama, String email, String position) async {
  final db = await initDb();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');

  if (userId == null) return 0;

  return await db.update(
    'users',
    {
      'nama': nama,
      'email': email,
      'position': position,
    },
    where: 'id = ?',
    whereArgs: [userId],
  );
}

}