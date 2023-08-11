import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/constant.dart';
import 'package:todo_list/data.dart';
import 'package:todo_list/priority_choose_box.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity newTaskEntity;

  const EditTaskScreen({
    Key? key,
    required this.newTaskEntity,
  }) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController controller =
      TextEditingController(text: widget.newTaskEntity.name);
  final SnackBar snackBar = const SnackBar(
    
    content: Text('Your task cant be empty.'),
  );
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: themeData.colorScheme.surface,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (controller.text == "") {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              widget.newTaskEntity.name = controller.text;
              if (widget.newTaskEntity.isInBox) {
                widget.newTaskEntity.save(); //Update
              } else {
                final Box<TaskEntity> taskBox =
                    Hive.box<TaskEntity>(taskBoxName);
                taskBox.add(widget.newTaskEntity); //Add
              }
              Navigator.of(context).pop();
            }
          },
          label: const Row(
            children: [
              Text("Save Changes"),
              SizedBox(width: 4),
              Icon(
                CupertinoIcons.check_mark,
                size: 18,
              )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeData.colorScheme.surface,
          foregroundColor: themeData.colorScheme.onSurface,
          title: const Text('Edit Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: PriorityChooseBox(
                      gestureDetectorCallBack: () {
                        setState(() {
                          widget.newTaskEntity.priority = Priority.high;
                        });
                      },
                      label: 'High',
                      color: highPriorityColor,
                      isSelected:
                          widget.newTaskEntity.priority == Priority.high,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: PriorityChooseBox(
                      gestureDetectorCallBack: () {
                        setState(() {
                          widget.newTaskEntity.priority = Priority.normal;
                        });
                      },
                      label: 'Normal',
                      color: normalPriorityColor,
                      isSelected:
                          widget.newTaskEntity.priority == Priority.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: PriorityChooseBox(
                      gestureDetectorCallBack: () {
                        setState(() {
                          widget.newTaskEntity.priority = Priority.low;
                        });
                      },
                      label: 'Low',
                      color: lowPriorityColor,
                      isSelected: widget.newTaskEntity.priority == Priority.low,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text(widget.newTaskEntity.name.isEmpty
                      ? "Add Task for To day"
                      : "Edit Your Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

