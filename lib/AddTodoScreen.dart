import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TodoModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  static const String id = 'add_todo';
  final Todo? todo;

  const AddTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddTodoScreenState(todo);
}

class AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController textController = TextEditingController();
  DateTime? notifyAt;
  Todo? todo; // if null => create new to do, else edit this

  AddTodoScreenState(this.todo) {
    if (todo != null) {
      notifyAt = todo!.notifyAt;
      textController.text = todo!.description;
    }
  }

  void apply(context) {
    if (todo == null) {
      // create new
      Navigator.of(context).pop({
        'description': textController.text,
        'notifyAt': notifyAt?.toString()
      });
    } else {
      // edit to do
      final map = todo!.toMap();
      map['description'] = textController.text;
      map['notifyAt'] = notifyAt?.toString();
      Navigator.of(context).pop(map);
    }
  }

  String prettyNotifyAt(DateTime datetime) {
    return DateFormat('dd/MM/yy HH:mm').format(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('New Todo')),
        //body: TextField(controller: textController),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: textController,
                maxLength: 500,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Your todo:',
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.date_range),
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: todo?.notifyAt ?? DateTime.now(),
                          maxTime: DateTime(2049, 12, 31, 23, 59, 59),
                          onConfirm: (date) { setState(() { notifyAt = date; }); },
                          currentTime: notifyAt ?? DateTime.now(),
                          locale: LocaleType.en);
                    },
                    child: Text(notifyAt == null
                        ? 'Choose date'
                        : prettyNotifyAt(notifyAt!))),
                notifyAt == null
                    ? const Center()
                    : IconButton(
                        onPressed: () { setState(() { notifyAt = null; }); },
                        icon: Icon(
                          Icons.cancel_sharp,
                          color: Colors.red[800],
                        )),
              ],
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            apply(context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.done),
        ));
  }
}
