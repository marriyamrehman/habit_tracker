import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  // --- Shared Preferences Functions ---

  // Save the habits list to local storage
  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitNames = _habits.map((habit) => habit['name'] as String).toList();
    final habitDone = _habits.map((habit) => habit['done'].toString()).toList();
    final habitStreak = _habits.map((habit) => habit['streak'].toString()).toList();

    await prefs.setStringList('habitNames', habitNames);
    await prefs.setStringList('habitDone', habitDone);
    await prefs.setStringList('habitStreak', habitStreak);
  }

  // Load the habits list from local storage
  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList('habitNames');
    final done = prefs.getStringList('habitDone');
    final streak = prefs.getStringList('habitStreak');

    if (names != null && done != null && streak != null) {
      setState(() {
        _habits.clear();
        for (int i = 0; i < names.length; i++) {
          _habits.add({
            'name': names[i],
            'done': done[i] == 'true',
            'streak': int.tryParse(streak[i]) ?? 0,
          });
        }
      });
    }
  }

  // --- Add Habit Dialog ---
  void _showAddHabitDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Habit Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _habits.add({
                    'name': nameController.text.trim(),
                    'done': false,
                    'streak': 0,
                  });
                });
                _saveHabits();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // --- Toggle habit status ---
  void _toggleHabit(Map<String, dynamic> habit) {
    setState(() {
      habit['done'] = !habit['done'];
    });
    _saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text(
                'No habits yet.\nTap + to add your first habit!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: InkWell(
                      onTap: () => _toggleHabit(habit),
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(
                        habit['done']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 32,
                        color: habit['done'] ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(
                      habit['name'],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: habit['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('${habit['streak']} day streak'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _toggleHabit(habit),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
