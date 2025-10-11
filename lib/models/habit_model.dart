class Habit {
  final int? id;
  final String name;
  final bool isCompleted;

  Habit({this.id, required this.name, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
