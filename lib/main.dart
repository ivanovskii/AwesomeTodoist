import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_todoist/AddTodoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awesome Todoist',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Awesome Todoist'),
      routes: {
        MyHomePage.id: (context) => MyHomePage(title: 'Awesome Todoist'),
        AddTodoScreen.id: (context) => AddTodoScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  static const String id = 'main';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void addTodo() async {
    var ats = AddTodoScreen();
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return ats; })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.square_list_fill),
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
