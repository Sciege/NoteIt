import 'package:freezed_annotation/freezed_annotation.dart';

part 'priv_notes.freezed.dart'; // dart run build_runner build --delete-conflicting-outputs

@freezed
abstract class PrivNotes with _$PrivNotes {
  const factory PrivNotes({
    dynamic key,
    required String title,
    required String content,
  }) = _PrivNotes;
}
