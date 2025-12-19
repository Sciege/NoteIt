import '../../domain/models/note.dart' as domain;
import '../../data/models/note.dart' as data;

// Hive to Freezed (Reading from DB)
extension NoteHiveMapper on data.Note {
  domain.Note toDomain() {
    return domain.Note(
      key: key,
      title: title,
      content: content,
      isPinned: isPinned,
    );
  }
}

//  Freezed to Hive (Saving to DB local)
extension NoteDomainMapper on domain.Note {
  data.Note toEntity() {
    return data.Note.create(
        title: title,
        content: content,
        isPinned: isPinned
    );
  }
}