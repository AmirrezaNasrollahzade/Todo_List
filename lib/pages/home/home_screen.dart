import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/repository/repository.dart';
import 'package:todo_list/pages/edit/edit_task_screen.dart';
import 'package:todo_list/util/constant.dart';
import 'package:todo_list/widgets/widgets.dart';
import 'package:todo_list/data/model/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Attributes
  TextEditingController controller = TextEditingController();
  // ValueNotifier<String> searchKeyWordNotifier = ValueNotifier("");
  //Override
  @override
  Widget build(BuildContext context) {
    //Values
    final themeData = Theme.of(context);
    //Return
    return SafeArea(
      child: Scaffold(
        //FloatingActionButton
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          onPressed: () {
            ///send a new task box
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    EditTaskScreen(newTaskEntity: TaskEntity())));
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
        //Body
        body: Column(
          children: [
            //AppBar Custom
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
                            style: themeData.textTheme.titleLarge!
                                .apply(color: themeData.colorScheme.onPrimary)),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
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

                      ///Search Task TextField
                      child: TextField(
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
            //ListView Tasks
            Expanded(
              ///this ValueListenableBuilder is for SearchKeyWord in SearchBox
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return Consumer<Repository<TaskEntity>>(
                    builder: (context, repository, child) {
                      return FutureBuilder(
                        future: repository.localDataSource
                            .getAll(searchByKeyword: controller.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return TaskList(
                                  items: snapshot.data!, themeData: themeData);
                            } else {
                              return const EmptyState();
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                                strokeAlign: 2.25,
                                color: themeData.colorScheme.onBackground,
                              ),
                            );
                          }
                        },
                      );
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

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length + 1,
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
                    style: themeData.textTheme.titleLarge!.apply(
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
                onPressed: () async {
                  final repositoryProvider =
                      Provider.of<Repository<TaskEntity>>(context,
                          listen: false);
                  repositoryProvider.deleteAll();
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
    );
  }
}

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
          //delete the task
          final repositoryProvider =
              Provider.of<Repository<TaskEntity>>(context, listen: false);
          repositoryProvider.delete(data: widget.task);
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
                  widget.task.save();
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
