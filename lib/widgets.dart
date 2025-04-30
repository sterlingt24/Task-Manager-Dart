//widgets.dart
//4.30.25
//Tyson Sterling
//Widget build for each "task box"

import 'package:flutter/material.dart';
import '../model.dart';

class TaskBox extends StatefulWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const TaskBox({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

//visibility check for Complete and Delete Buttons
class _TaskBoxState extends State<TaskBox> {
  bool showOptions = false;
  bool isEditing = false;
  late TextEditingController _controller;

  //initialize text field controller with task title
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
  }

  //controller cleanup when widget removal 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Edit Toggle and save changes
  void toggleEdit() {
    if (isEditing) {
      widget.onEdit(_controller.text);
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  //Widget Build
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: isEditing
                      ? TextField(
                          controller: _controller,
                          autofocus: true,
                          onSubmitted: (_) => toggleEdit(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        )
                      : Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: toggleEdit,
                  tooltip: isEditing ? 'Save' : 'Edit Task',
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  showOptions = !showOptions;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.arrow_drop_down_circle_outlined),
                  SizedBox(width: 4),
                  Text("Options"),
                ],
              ),
            ),
            if (showOptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: widget.onComplete,
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text('Complete',
                        style: TextStyle(color: Colors.green)),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
