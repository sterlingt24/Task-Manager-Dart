//Model for task title and to track completed tasks

//future update ideas: Completion count

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}