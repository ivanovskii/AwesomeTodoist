import 'package:flutter/material.dart';
import 'TodoModel.dart';

class AddTodoScreen extends StatelessWidget {
  static const String id = 'add_todo';
  TextEditingController textController = TextEditingController();
  Todo? todo;

  AddTodoScreen({Key? key, this.todo}) : super(key: key) {
    if (todo != null) {
      textController.text = todo!.description;
    }
  }

  void apply(context) {
    var map = todo?.toMap();
    map?['description'] = textController.text;
    Navigator.of(context).pop(
      map ?? {'description': textController.text}
    );
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
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () { apply(context); },
          backgroundColor: Colors.green,
          child: const Icon(Icons.done),
        )
    );
  }

}