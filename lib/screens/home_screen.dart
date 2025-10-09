import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Map<String, dynamic>> _habits = [];

  final TextEditingController _controller = TextEditingController();

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

  Future<void> _addHabit(String name) async {
    if (name.isEmpty) return;

    await _dbHelper.insertHabit({'name': name, 'completed': 0});
    _controller.clear();
    _loadHabits();
  }

  Future<void> _toggleHabit(int id, int completed) async {
    await _dbHelper.updateHabit({
      'id': id,
      'name': _habits.firstWhere((h) => h['id'] == id)['name'],
      'completed': completed == 1 ? 0 : 1,
    });
    _loadHabits();
  }

  Future<void> _deleteHabit(int id) async {
    await _dbHelper.deleteHabit(id);
    _loadHabits();
  }

  void _showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF211832),
        title: const Text(
          'Add New Habit',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter habit name',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF25912),
            ),
            onPressed: () {
              _addHabit(_controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211832),
      appBar: AppBar(
        title: const Text('My Habits'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF25912),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: const Color(0xFF5C3E94),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text(
                'No habits yet. Tap + to add one!',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  color: const Color(0xFF412B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: const Color(0xFFF25912),
                      value: habit['completed'] == 1,
                      onChanged: (_) => _toggleHabit(habit['id'], habit['completed']),
                    ),
                    title: Text(
                      habit['name'],
                      style: TextStyle(
                        color: Colors.white,
                        decoration: habit['completed'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteHabit(habit['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
