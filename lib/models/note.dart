import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String id;
  String title;
  String description;
  Timestamp date;
  String uid;

  NoteModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.uid});

  factory NoteModel.fromJson(DocumentSnapshot snapshot) {
    return NoteModel(
        id: snapshot.id,
        title: snapshot.get('title'),
        description: snapshot.get('description'),
        date: snapshot.get('date'),
        uid: snapshot.get('userId')
        );
  }
}
