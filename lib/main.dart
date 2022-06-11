import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddTodoScreen.dart';
import 'SQLHelper.dart';
import 'TodoModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
        MyHomePage.id: (context) => const MyHomePage(title: 'Awesome Todoist'),
        AddTodoScreen.id: (context) => const AddTodoScreen()
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

  var database = SQLHelper();

  List<Todo> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    var data = await database.all();
    setState(() {
      list = data.map((e) => Todo.fromMap(e)).toList();
    });
  }

  void addTodo() async {
    final res = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return const AddTodoScreen(); })
    );
    if (res != null && res['description'] != '') {
      int? id = await database.insert(Todo.fromMap(res));
      if (res['notifyAt'] != null) {
        notify(id, res['description'], DateTime.parse(res['notifyAt']));
      }
      refreshList();
    }
  }

  void updateTodo(int index) async {
    final res = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) { return AddTodoScreen(todo: list[index]); })
    );

    cancelNotifyIfExist(list[index]);

    if (res != null && res['description'] != '') {
      int? id = await database.update(Todo.fromMap(res));
      if (res['notifyAt'] != null) {
        notify(id, res['description'], DateTime.parse(res['notifyAt']));
      }
      refreshList();
    }
  }

  void deleteTodo(int index) async {
    cancelNotifyIfExist(list[index]);
    int id = list[index].id!;
    await database.delete(id);
    refreshList();
  }

  void changeStatus(int index) async {
    setState(() {
      list[index].done = !list[index].done;
    });
    await database.update(list[index]);
  }

  void cancelNotifyIfExist(Todo todo) {
    if (todo.notifyAt != null) {
      flutterLocalNotificationsPlugin.cancel(todo.id!);
    }
  }

  void notify(int? id, String title, DateTime notifyAt) async {
    if (notifyAt.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(
          id!,
          'respect+',
          title,
          notifyAt,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                'AwesomeTodoist Channel Id',
                'AwesomeTodoist Channel Name',
                channelDescription: 'AwesomeTodoist Channel Desc',
                channelShowBadge: true,
                priority: Priority.high,
                importance: Importance.max,
                icon: 'notification_icon',
                sound: RawResourceAndroidNotificationSound('notification_sound'),
                playSound: true,
              )
          )
      );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.square_list_fill),
        title: Text(widget.title),
      ),
      body: list.isNotEmpty ? ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Todo item = list[index];
          return ListTile(
            title: Text(item.description),
            subtitle: Text(
                '${item.done ? 'Done' : 'Not done'} | ${item.prettyNotifyAt() ?? 'No date'}',
                style: const TextStyle(
                  fontSize: 12,
                ),
            ),
            leading: Checkbox(
                onChanged: (value) { changeStatus(index); },
                value: item.done,
                activeColor: Colors.green
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () { updateTodo(index); },
                    icon: const Icon(Icons.edit, color: Colors.deepPurple,)
                ),
                IconButton(
                    onPressed: () { deleteTodo(index); },
                    icon: const Icon(Icons.delete, color: Colors.redAccent,)
                ),
              ],
            ),
          );
        }
      ) : const Center(child: Text('No items')),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
