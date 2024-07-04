import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson_68/services/note_service.dart';

class NotesController {
  final _notesFireStore = NoteFireStoreService();

  Stream<QuerySnapshot> getNotes() {
    return _notesFireStore.getNotes();
  }

  void updateNote(String id, bool isDone,
      {String? title, Timestamp? date}) async {
    _notesFireStore.updateNote(id, isDone, title: title, date: date);
  }

  void deleteNote(String id) {
    _notesFireStore.deleteNote(id);
  }
}
