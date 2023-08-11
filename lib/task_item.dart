import 'package:flutter/material.dart';
import 'package:todo_list/constant.dart';
import 'package:todo_list/data.dart';
import 'package:todo_list/edit_task_screen.dart';
import 'package:todo_list/my_check_box.dart';

class TaskItem extends StatefulWidget {
  static const double height = 84;
  final TaskEntity task;

  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    Color? priorityColor;
    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      default:
    }
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onLongPress: () {
        setState(() {
          widget.task.delete();
        });
      },
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditTaskScreen(newTaskEntity: widget.task),
              ));
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 5),
        padding: const EdgeInsets.only(left: 15, right: 0, bottom: 0, top: 0),
        height: TaskItem.height,
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
              checkBox: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            Container(
              height: TaskItem.height,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: priorityColor,
              ),
            ),
            // Text("${widget.task.priority}"),
          ],
        ),
      ),
    );
  }
}
