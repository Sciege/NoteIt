import '../../domain/models/todolist.dart' as domain;
import '../../data/models/todolist.dart' as data;

// Hive to Freezed (Reading from DB)
extension NoteHiveMapper on data.Todolist {
  domain.Todolist toDomain() {
    return domain.Todolist(
      todolist: todoList,
      description: description,
      isDone: isDone,
    );
  }
}

// Freezed to Hive (Saving to DB local)
extension NoteDomainMapper on domain.Todolist {
  data.Todolist toEntity() {
    return data.Todolist.create(
      todoList: todolist,
      description: description,
      isDone: isDone,
    );
  }
}
