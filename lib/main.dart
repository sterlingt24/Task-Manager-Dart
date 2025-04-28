//main format of application (view)
//Future Updates: Visuals for model view interaction

import 'package:flutter/material.dart';
import 'model.dart';
import 'widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
    print(
      "Task Completed: ${tasks[index].title}",
    ); //fix for future, currently just for logging
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
  void initState() {
    super.initState();
    loadTasks(); // Load saved tasks on startup
}


  // Get the local file path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the file where we save tasks
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  // Save tasks to a local file
  Future<void> saveTasks() async {
    final file = await _localFile;
    List<Map<String, dynamic>> taskData =
        tasks
            .map(
              (task) => {'title': task.title, 'isCompleted': task.isCompleted},
            )
            .toList();
    await file.writeAsString(jsonEncode(taskData));
  }

  // Load tasks from a local file
  Future<void> loadTasks() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<dynamic> jsonData = jsonDecode(contents);
        setState(() {
          tasks =
              jsonData
                  .map(
                    (task) => Task(
                      title: task['title'],
                      isCompleted: task['isCompleted'] ?? false,
                    ),
                  )
                  .toList();
        });
      }
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Tasks',
            onPressed: () async {
              await saveTasks();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Tasks Saved!')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Load Tasks',
            onPressed: () async {
              await loadTasks();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Tasks Loaded!')));
            },
          ),
        ],
      ),

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
