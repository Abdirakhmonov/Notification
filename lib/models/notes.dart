
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  bool isDone;
  Timestamp date;

  Note({
    required this.id,
    required this.title,
    required this.date,
    required this.isDone,
  });

  factory Note.fromJson(QueryDocumentSnapshot snap) {
    return Note(
      id: snap.id,
      title: snap["title"],
      date: snap['date'],
      isDone: snap['isDone'],
    );
  }
}
