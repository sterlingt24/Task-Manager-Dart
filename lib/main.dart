//main.dart
//4.30.25
//Tyson Sterling
//main format of application (view) with UI and state sets and references to the model for data
//Future Updates: Visuals for model view interaction

import 'package:flutter/material.dart';
import 'model.dart';
import 'widgets.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//Build/Initialize
void main() {
  runApp(const MyApp());
}

//Stateless Widget
class MyApp extends StatelessWidget {
  //Key for Widget Tracking
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Material App is the Visual Theme
    return MaterialApp(
      //Debug Title
      title: 'Task Dropdown Demo',
      //Default Color Setting
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 72, 0)),
        //"Material You" Set True (Material System)
        useMaterial3: true,
      ),
      //Set Main Page to Default
      home: const MainPage(title: 'Tasks'),
    );
  }
}

//UI Update on State Change
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
//Widget to State Class Connection
  State<MainPage> createState() => _MainPageState();
}

//Task Object to Hold Task List
class _MainPageState extends State<MainPage> {
  List<Task> tasks = [
    Task(title: "Task: Enter Task"),
    Task(title: "Task: Enter Task"),
    Task(title: "Task: Enter Task"),
  ];

  //taskManager to Manage Logic with Milestone Check and other methods
  final TaskManager taskManager = TaskManager();
  String? milestoneLabel;

  //New Task with Updated UI through setState Rebuild
  void _addTask() {
    setState(() {
      tasks.add(Task(title: "New Task"));
    });
  }

  //Model Update, UI Removal 
  void _completeTask(int index) {
    //Syncing TaskManager With Current Tasks
    taskManager.tasks = List.from(tasks);
    String? reward = taskManager.completeTask(index);
    setState(() {
      tasks.removeAt(index);
      milestoneLabel = reward;
    });

    if (reward != null) {
      _showMilestonePopup(reward);
    }
  }

  //Update UI with setState Rebuild
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

  //showDialog is Completeion Popup, barrierDismissible is for Force Exit Button
  void _showMilestonePopup(String rewardLabel) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        //UI Display for Popup
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Stack( //Allows Overlapping Elements
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        '🎉 Milestone Reached!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        rewardLabel,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Local File Path Get Method
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //Local File Save Get Method
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  //Save Tasks to a Local File with JSON
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

  //Load tasks from a Local File wiht JSON
  Future<void> loadTasks() async {
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
  }

  //Main UI Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //For The Save Load Buttons 
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

      //Task Dragging Build 
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final task = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, task);
          });
        },
        //Task Box Widget, Unique Key is ListTile
        itemBuilder: (context, index) {
          return ListTile(
            key: ValueKey(tasks[index]),
            title: TaskBox(
              task: tasks[index],
              onComplete: () => _completeTask(index),
              onDelete: () => _deleteTask(index),
              onEdit: (newTitle) => _updateTaskTitle(index, newTitle),
            ),
          );
        },
      ),

      //Button for New Tasks
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
