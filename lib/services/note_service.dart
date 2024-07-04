
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteFireStoreService {
  final _noteService = FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getNotes() async* {
    yield* _noteService.snapshots();
  }

  void updateNote(
      String id,
      bool isDone, {
        String? title,
        Timestamp? date,
      }) async {
    await _noteService.doc(id).set(
      {
        "isDone": isDone,
        if (title != null) "title": title,
        if (date != null) "date": date,
      },
    );
  }

  void deleteNote(String id) async {
    await _noteService.doc(id).delete();
  }
}
