import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/repository/repository.dart';
import 'package:todo_list/data/source/hive_task_source.dart';
import 'package:todo_list/util/constant.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/pages/home/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  //flutter packages pub run build_runner build
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  //SetSystemUIOverlayStyle
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor));
  // //Providers
  // Provider.debugCheckInvalidValueType = null;
  runApp(
    ChangeNotifierProvider(
      create: (context) => Repository(
          localDataSource: HiveTaskDataSource(box: Hive.box(taskBoxName))),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: backgroundColor,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondaryTextColor),
          iconColor: secondaryTextColor,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryContainer,
          onPrimary: Colors.white,
          background: backgroundColor,
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
