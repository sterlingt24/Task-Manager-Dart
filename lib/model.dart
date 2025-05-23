//model.dart
//4.30.25
//Tyson Sterling
//Model for task title and to track completed tasks with data stored here
//future update ideas: Updates to milestone displays and different data aspects

class Task {
  String title; //Task Name
  bool isCompleted; //Boolean for Done 

  //Task Constructor, Title is Required and isCompleted is false
  Task({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
      };

  //Map for JSON Serialization (Convert Data to JSON String)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TaskManager {
  List<Task> tasks = [];
  int completedCount = 0;

  final List<Map<String, dynamic>> milestones = [
    {'count': 5, 'label': '🏅 Rookie Completionist'},
    {'count': 10, 'label': '🎖️ Taking the Next Steps'},
    {'count': 25, 'label': '🏆 Task Master'},
  ];

  void addTask(String title) {
    tasks.add(Task(title: title));
  }

  /// Completes a task and removes it. Returns reward label if milestone hit.
  String? completeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      completedCount++;
      return _checkMilestone();
    }
    return null;
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
  }

  //Re Set with Index with newTitle
  void updateTaskTitle(int index, String newTitle) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].title = newTitle;
    }
  }

  //Check Stored Value for completions
  String? _checkMilestone() {
    for (var milestone in milestones) {
      if (completedCount == milestone['count']) {
        return milestone['label'];
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'completedCount': completedCount,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };

  void fromJson(Map<String, dynamic> json) {
    completedCount = json['completedCount'] ?? 0;
    tasks = (json['tasks'] as List).map((t) => Task.fromJson(t)).toList();
  }
}
