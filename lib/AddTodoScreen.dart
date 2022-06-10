import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TodoModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddTodoScreen extends StatelessWidget {
  static const String id = 'add_todo';

  TextEditingController textController = TextEditingController();
  DateTime? notifyAt;

  Todo? todo; // if null => create new to do, else edit this
  AddTodoScreen({Key? key, this.todo}) : super(key: key) {
    if (todo != null) {
      notifyAt = todo!.notifyAt;
      textController.text = todo!.description;
    }
  }

  void apply(context) {
    if (todo == null) { // create new
      Navigator.of(context).pop(
          {
            'description': textController.text,
            'notifyAt': notifyAt?.toString()
          }
      );
    }
    else { // edit to do
      final map = todo!.toMap();
      map['description'] = textController.text;
      map['notifyAt'] = notifyAt?.toString();
      Navigator.of(context).pop(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('New Todo')
        ),
        //body: TextField(controller: textController),
        body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20
                  ),
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
                  )
              ),
            TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: todo?.notifyAt ?? DateTime.now(),
                      maxTime: DateTime(2049, 12, 31, 23, 59, 59),
                      onConfirm: (date) {
                        notifyAt = date;
                      },
                      currentTime: notifyAt ?? DateTime.now(),
                      locale: LocaleType.en
                  );
                },
                child: Text(
                  'show date time picker',
                )
            )
        ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { apply(context); },
          backgroundColor: Colors.green,
          child: const Icon(Icons.done),
        )
    );
  }

}