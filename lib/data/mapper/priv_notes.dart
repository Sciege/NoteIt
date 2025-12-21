import '../../domain/models/priv_notes.dart' as domain;
import '../../data/models/priv_notes.dart' as data;

// Hive to Freezed (Reading from DB)
extension NoteHiveMapper on data.PrivNotes {
  domain.PrivNotes toDomain() {
    return domain.PrivNotes(
      key: key,
      title: title,
      content: content,
    );
  }
}

//  Freezed to Hive (Saving to DB local)
extension NoteDomainMapper on domain.PrivNotes {
  data.PrivNotes toEntity() {
    return data.PrivNotes.create(
        title: title,
        content: content,
    );
  }
}