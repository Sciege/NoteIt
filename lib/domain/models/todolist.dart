import 'package:freezed_annotation/freezed_annotation.dart';

part 'todolist.freezed.dart';

@freezed
abstract class Todolist with _$Todolist {
  const factory Todolist({
    dynamic key,
    required String todolist,
    required String description,
    @Default(false) bool isDone,
  }) = _Todolist;
}
