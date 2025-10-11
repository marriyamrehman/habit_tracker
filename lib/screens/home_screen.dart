import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/habit_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final data = await _dbHelper.getHabits();
    setState(() {
      _habits = data;
    });
  }

  Future<void> _addHabitDialog() async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Habit"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter habit name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _dbHelper.insertHabit(
                  Habit(name: controller.text.trim(), isCompleted: false),
                );
                Navigator.pop(context);
                _loadHabits();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _editHabitDialog(Habit habit) async {
    final TextEditingController controller =
        TextEditingController(text: habit.name);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Habit"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await _dbHelper.updateHabit(
                  Habit(
                    id: habit.id,
                    name: controller.text.trim(),
                    isCompleted: habit.isCompleted,
                  ),
                );
                Navigator.pop(context);
                _loadHabits();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHabit(int id) async {
    await _dbHelper.deleteHabit(id);
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A103D),
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return Card(
            color: Colors.deepPurple.shade400,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Checkbox(
                value: habit.isCompleted,
                onChanged: (value) async {
                  await _dbHelper.updateHabit(
                    Habit(
                      id: habit.id,
                      name: habit.name,
                      isCompleted: value ?? false,
                    ),
                  );
                  _loadHabits();
                },
                activeColor: Colors.orange,
              ),
              title: Text(
                habit.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () => _editHabitDialog(habit),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteHabit(habit.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _addHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
