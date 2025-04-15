//main format of application (view)
//Future Updates: Visuals for model view interaction

import 'package:flutter/material.dart';
import 'model.dart'; 
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Dropdown Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Tasks'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Task> tasks = [
    Task(title: "Task 1: Enter Task"),
    Task(title: "Task 2: Enter Task"),
    Task(title: "Task 3: Enter Task"),
  ];

  void _addTask() {
    setState(() {
      tasks.add(Task(title: "New Task"));
    });
  }

  void _completeTask(int index) {
    print("Task Completed: ${tasks[index].title}"); //fix for future, currently just for logging
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _updateTaskTitle(int index, String newTitle) {
    setState(() {
      tasks[index].title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskBox(
            task: tasks[index],
            onComplete: () => _completeTask(index),
            onDelete: () => _deleteTask(index),
            onEdit: (newTitle) => _updateTaskTitle(index, newTitle),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
