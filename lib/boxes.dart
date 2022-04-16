import 'package:hive/hive.dart';
import 'package:to_do_app/model/todo.dart';

class Boxes {
  static Box<ToDo> getToDos() => Hive.box<ToDo>('todos');
}
