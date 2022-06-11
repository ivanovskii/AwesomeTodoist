import 'package:intl/intl.dart';

class Todo {
  int? id;
  String description = '';
  DateTime? notifyAt;
  bool done = false;

  Todo({this.id, required this.description, this.notifyAt});

  String? prettyNotifyAt([DateFormat? formatter]) {
    formatter??=DateFormat('dd/MM/yy HH:mm');
    return notifyAt == null ? null : formatter.format(notifyAt!);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'description': description,
      'notifyAt': notifyAt?.toString(), // null aware operator
      'done': done ? 1 : 0 // bool is not a supported SQLite type
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    description = map['description'];
    notifyAt = map['notifyAt'] == null ? null : DateTime.parse(map['notifyAt']);
    done = map['done'] == 1 ? true : false;
  }
}
