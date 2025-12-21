import 'package:hive/hive.dart';

part 'priv_notes.g.dart'; // used dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 3)
class PrivNotes extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  PrivNotes({required this.title, required this.content});

  PrivNotes.create({
    required this.title,
    required this.content,
  });

}
