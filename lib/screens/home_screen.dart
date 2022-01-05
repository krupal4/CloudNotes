import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_12dec/models/note.dart';
import 'package:firebase_12dec/screens/createnote_screen.dart';
import 'package:firebase_12dec/screens/editnote_screen.dart';
import 'package:firebase_12dec/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  User user;
  HomeScreen(this.user);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Notes',
          ),
          centerTitle: true,
          backgroundColor: Colors.pink[500],
          actions: [
            TextButton.icon(
              onPressed: () async {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title:const Text('Please confirm'),
                    content: const Text('Are you sure to log out ?'),
                    actions: [
                      ElevatedButton(onPressed: ()async{
                        Navigator.of(context).pop();
                          await AuthService().signOut();
                      }, child: const Text('LOG OUT'),
                        style: ElevatedButton.styleFrom(primary:Colors.deepOrange),
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      },  child: const Text('Cancel')
                      )
                    ],
                  );
                });
              
              },
              icon: const Icon(Icons.logout),
              label: const Text('LOG OUT'),
              style: TextButton.styleFrom(primary: Colors.white),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNoteScreen(widget.user)));
          },
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .where('userId', isEqualTo: widget.user.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      NoteModel myNote =
                          NoteModel.fromJson(snapshot.data.docs[index]);
                      return Card(
                        color: Colors.teal,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          title: Text(
                            myNote.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            myNote.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNoteScreen(myNote)));
                          },
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text('No notes available.'),
                );
              }
            } else {
              return const Center(child:CircularProgressIndicator());
            }
          },
        ));
  }
}
