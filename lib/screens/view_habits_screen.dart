import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class ViewHabitsScreen extends StatefulWidget {
  const ViewHabitsScreen({Key? key}) : super(key: key);

  @override
  State<ViewHabitsScreen> createState() => _ViewHabitsScreenState();
}

class _ViewHabitsScreenState extends State<ViewHabitsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final data = await _dbHelper.getAllHabits();
    setState(() {
      _habits = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211832),
      appBar: AppBar(
        title: const Text(
          "All Habits",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF25912),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text(
                "No habits found.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  color: const Color(0xFF412B6B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(
                      habit['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      habit['isCompleted'] == 1
                          ? "✅ Completed"
                          : "❌ Not Completed",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
