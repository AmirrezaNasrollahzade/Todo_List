import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/constant.dart';
import 'package:todo_list/edit_task_screen.dart';
import 'data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final Box<TaskEntity> taskBox = Hive.box<TaskEntity>(taskBoxName);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const EditTaskScreen(),
          ));
        },
        label: const Row(
          children: [
            Text(
              'Add New Task',
            ),
            SizedBox(width: 5),
            Icon(CupertinoIcons.add_circled_solid)
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 102,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Do List',
                            style: themeData.textTheme.headline6!
                                .apply(color: themeData.colorScheme.onPrimary)),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    //  const  SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.1,
                            ),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none, //new Learn
                          prefixIcon: const Icon(CupertinoIcons.search),
                          label: Text(
                            'Search task...',
                            style: themeData.inputDecorationTheme.labelStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, box, child) {
                  List<TaskEntity> listTask = taskBox.values.toList();
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: taskBox.values.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: themeData.textTheme.headline6!.apply(
                                    color: themeData.colorScheme.onBackground,
                                    fontSizeFactor: 0.9,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  height: 3,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: themeData.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                )
                              ],
                            ),
                            MaterialButton(
                              color: const Color(0xffEAEFF5),
                              textColor: secondaryTextColor,
                              onPressed: () {},
                              elevation: 0,
                              child: const Row(
                                children: [
                                  Text(
                                    'Delete All',
                                  ),
                                  SizedBox(width: 4),
                                  Icon(CupertinoIcons.delete_solid),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        final TaskEntity task = listTask[index - 1];
                        return TaskItem(task: task);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 5),
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
        height: 80,
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 20,
          //     color: Colors.black.withOpacity(0.3),
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyCheckBox(value: widget.task.isCompleted),
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
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;

  const MyCheckBox({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: !value ? Border.all(color: secondaryTextColor, width: 2) : null,
        color: value ? primaryColor : null,
      ),
      child: value
          ? Icon(CupertinoIcons.check_mark,
              size: 16, color: themeData.colorScheme.onPrimary)
          : null,
    );
  }
}
