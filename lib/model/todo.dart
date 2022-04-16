import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class ToDo extends HiveObject {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late int colorNumber;
  @HiveField(3)
  late bool completed;

  ToDo(
      {required this.title,
      required this.colorNumber,
      required this.completed});
}
