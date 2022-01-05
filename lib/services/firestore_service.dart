import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertNote(String title, String description, String userId,
      BuildContext context) async {
    try {
      await firestore.collection('notes').add({
        'title': title,
        'description': description,
        'date': DateTime.now(),
        'userId': userId
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString(),
              style: const TextStyle(backgroundColor: Colors.red))));
    }
  }

  Future updateNote(
      String id, String title, String description, BuildContext context) async {
    try {
      await firestore
          .collection('notes')
          .doc(id)
          .update({'title': title, 'description': description});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString(),
              style: const TextStyle(backgroundColor: Colors.red))));
    }
  }

  Future deleteNote(String id, BuildContext context) async {
    try {
      await firestore.collection('notes').doc(id).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString(),
              style: const TextStyle(backgroundColor: Colors.red))));
    }
  }
}
