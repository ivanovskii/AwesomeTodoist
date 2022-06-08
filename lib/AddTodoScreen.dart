import 'package:flutter/material.dart';

class AddTodoScreen extends StatelessWidget {
  static const String id = 'add_todo';

  void apply(context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('New Todo')
        ),
        body: const Center(child: Text("New Screen")),
        floatingActionButton: FloatingActionButton(
          onPressed: () { apply(context); },
          child: const Icon(Icons.done),
        )
    );
  }

}