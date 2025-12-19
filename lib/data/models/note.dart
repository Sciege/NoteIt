import 'package:hive/hive.dart';

part 'note.g.dart'; // used dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isPinned;

  Note({required this.title, required this.content, this.isPinned = false});

  Note.create({
    required this.title,
    required this.content,
    this.isPinned = false,
  });

}
