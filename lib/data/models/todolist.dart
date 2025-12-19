import 'package:hive/hive.dart';

part 'todolist.g.dart'; //dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 1)
class Todolist extends HiveObject {
  @HiveField(0)
  String todoList;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isDone;

  Todolist({required this.todoList, required this.description, required this.isDone});
}
