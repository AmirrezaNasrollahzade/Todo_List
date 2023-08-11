import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/constant.dart';
import 'package:todo_list/edit_task_screen.dart';
import 'package:todo_list/empty_state.dart';
import 'package:todo_list/task_item.dart';
import 'data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<String> searchKeyWordNotifier = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final Box<TaskEntity> taskBox = Hive.box<TaskEntity>(taskBoxName);
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(newTaskEntity: TaskEntity()),
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
        body: Column(
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
                      //Search Task TextField
                      child: TextField(
                        onChanged: (String value) {
                          searchKeyWordNotifier.value = value;
                        },
                        controller: controller,
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
                valueListenable: searchKeyWordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                    valueListenable: taskBox.listenable(),
                    builder: (context, box, child) {
                      final List<TaskEntity> items;
                      if (controller.text.isEmpty) {
                        items = taskBox.values.toList();
                      } else {
                        items = box.values
                            .where(
                                (task) => task.name.contains(controller.text))
                            .toList();
                      }
                      return box.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: items.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Today',
                                            style: themeData
                                                .textTheme.headline6!
                                                .apply(
                                              color: themeData
                                                  .colorScheme.onBackground,
                                              fontSizeFactor: 0.9,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            height: 3,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color:
                                                  themeData.colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(1.5),
                                            ),
                                          )
                                        ],
                                      ),
                                      MaterialButton(
                                        color: const Color(0xffEAEFF5),
                                        textColor: secondaryTextColor,
                                        onPressed: () async {
                                          await box.clear();
                                        },
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
                                  return TaskItem(task: items[index - 1]);
                                }
                              },
                            )
                          : const EmptyState();
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
