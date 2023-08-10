import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/constant.dart';
import 'package:todo_list/data.dart';



class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final task = TaskEntity();
          task.name = controller.text;
          task.priority = Priority.low;
          if (task.isInBox) {
            task.save(); //Update
          } else {
            final Box<TaskEntity> taskBox = Hive.box<TaskEntity>(taskBoxName);
            taskBox.add(task); //Add
          }
          Navigator.of(context).pop();
        },
        label: const Text("Save"),
      ),
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                label: Text("Add Task for To day"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
