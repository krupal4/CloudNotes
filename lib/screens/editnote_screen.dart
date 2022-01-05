import 'package:firebase_12dec/models/note.dart';
import 'package:firebase_12dec/services/firestore_service.dart';
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  NoteModel myNote;
  // const EditNoteScreen({ Key? key }) : super(key: key);
  EditNoteScreen(this.myNote);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.myNote.title;
    descriptionController.text = widget.myNote.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Please Confirm'),
                      content: const Text('Are you sure to delete the note ?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              FirestoreService()
                                  .deleteNote(widget.myNote.id, context);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'))
                      ],
                    );
                  });
            },
            color: Colors.redAccent,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: const Text(
                          'Update Note',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('All fields are required.'),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            FirestoreService().updateNote(
                                widget.myNote.id,
                                titleController.text,
                                descriptionController.text,
                                context);
                          }
                          setState(() {
                            loading = false;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
