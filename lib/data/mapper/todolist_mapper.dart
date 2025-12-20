import 'package:notes_it/data/models/todolist.dart' as hive;
import 'package:notes_it/domain/models/todolist.dart' as domain;

extension TodolistMapper on domain.Todolist {
  hive.Todolist toEntity() {
    return hive.Todolist(
      todoList: todolist,
      description: description,
      isDone: isDone,
    );
  }
}
