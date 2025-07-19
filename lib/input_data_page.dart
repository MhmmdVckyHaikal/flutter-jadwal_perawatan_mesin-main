import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDataPage extends StatefulWidget {
  const InputDataPage({super.key});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  DateTime _selectedDate = DateTime.now();
  final _timeController = TextEditingController();
  final _machineController = TextEditingController();
  String? _timeError;

  int _getDaysInMonth(int year, int month) {
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }
    return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int _getFirstDayOfMonth(DateTime date) {
    // Hari pertama bulan (1 = Senin, 7 = Minggu)
    int weekday = DateTime(date.year, date.month, 1).weekday;
    // Ubah ke 0 = Minggu, 1 = Senin, ..., 6 = Sabtu
    return (weekday % 7); // 1 (Senin) -> 1, 7 (Minggu) -> 0
  }

  Future<void> _selectYear(BuildContext context) async {
    int initialYear = _selectedDate.year;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Tahun'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                int year = initialYear + (index - 10);
                if (year < 1950 || year > 2050) return const SizedBox.shrink();
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: year == _selectedDate.year ? Colors.blue[200] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    year.toString(),
                    style: TextStyle(
                      color: year == _selectedDate.year ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  bool _isValidTime(String time) {
    if (time.isEmpty) return true;
    final parts = time.split(':');
    if (parts.length != 2) return false;
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) return false;
    return hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59;
  }

  @override
  Widget build(BuildContext context) {
    int firstDay = _getFirstDayOfMonth(_selectedDate); // Hari pertama bulan (0 = Minggu)
    int daysInMonth = _getDaysInMonth(_selectedDate.year, _selectedDate.month);
    int currentMonth = _selectedDate.month;
    int currentYear = _selectedDate.year;

    if (_timeController.text.isNotEmpty && !_isValidTime(_timeController.text)) {
      _timeError = 'Format jam harus HH:MM (0-23:0-59)';
    } else {
      _timeError = null;
    }

    // Hitung hari berdasarkan offset
    List<List<int>> calendarDays = List.generate(6, (row) => List.filled(7, 0));
    int currentDay = 1;
    for (int row = 0; row < 6 && currentDay <= daysInMonth; row++) {
      for (int col = 0; col < 7 && currentDay <= daysInMonth; col++) {
        if (row == 0 && col < firstDay) {
          calendarDays[row][col] = 0; // Hari kosong sebelum 1
        } else {
          calendarDays[row][col] = currentDay++;
        }
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Input Data Mesin',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E8C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _machineController,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Mesin',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E8C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _timeController,
                          onChanged: (value) {
                            setState(() {
                              _timeError = _isValidTime(value) ? null : 'Format jam harus HH:MM (0-23:0-59)';
                            });
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: 'Jeda Waktu Perawatan (jam)',
                            border: InputBorder.none,
                            hintText: 'Contoh: 10:30',
                            errorText: _timeError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _selectedDate = _selectedDate.month > 1
                                ? DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day)
                                : DateTime(_selectedDate.year - 1, 12, _selectedDate.day);
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectYear(context),
                          child: Text(
                            '${currentMonth.toString().padLeft(2, '0')}/$currentYear',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _selectedDate = _selectedDate.month < 12
                                ? DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day)
                                : DateTime(_selectedDate.year + 1, 1, _selectedDate.day);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        children: [
                          _buildDayCell('S'),
                          _buildDayCell('M'),
                          _buildDayCell('T'),
                          _buildDayCell('W'),
                          _buildDayCell('T'),
                          _buildDayCell('F'),
                          _buildDayCell('S'),
                        ],
                      ),
                      ...List<TableRow>.generate(6, (rowIndex) {
                        return TableRow(
                          children: List.generate(7, (colIndex) {
                            int day = calendarDays[rowIndex][colIndex];
                            if (day == 0) {
                              return _buildEmptyCell();
                            }
                            bool isSelected = day == _selectedDate.day &&
                                currentMonth == _selectedDate.month &&
                                currentYear == _selectedDate.year;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = DateTime(currentYear, currentMonth, day);
                                });
                              },
                              child: Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        color: const Color(0xFFF4A261),
                                        shape: BoxShape.circle,
                                      )
                                    : null,
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    day.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_machineController.text.isNotEmpty && _timeError == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data berhasil disimpan!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pastikan semua data valid!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(String day) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Center(),
    );
  }
}