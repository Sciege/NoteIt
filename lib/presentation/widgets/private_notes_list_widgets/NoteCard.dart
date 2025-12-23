import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/priv_notes.dart' as hive;
import '../../../domain/models/priv_notes.dart' as domain;

class Notecard extends StatelessWidget {
  Notecard({super.key, required this.note});

  final domain.PrivNotes note;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: () {
          //PrivateNotes
          context.go('/private_notes', extra: note);
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          // Have max characters trailing
          note.content.length >= 15
              ? note.content.substring(0, 15) + '...'
              : note.content,
          //note.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Icon(
            //     note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            //     color: note.isPinned ? const Color(0xFFF6D14C) : Colors.grey,
            //   ),
            //   onPressed: () {
            //     final updatedDomainNote = note.copyWith(
            //       isPinned: !note.isPinned,
            //     );
            //     final hiveNote = updatedDomainNote.toEntity();
            //     Hive.box<hive.PrivNotes>('notes').put(note.key, hiveNote);
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                Hive.box<hive.PrivNotes>('priv_notes').delete(note.key);
              },
            ),
          ],
        ),
      ),
    );
  }
}
