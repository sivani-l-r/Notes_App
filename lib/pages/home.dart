import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  final noteControl = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    readNotes();
  }
  void createNote()
  {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('N E W'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
        content: TextField(
          controller: noteControl,
          
        ),
        actions: [
          MaterialButton(
            onPressed: (){
                context.read<NoteDatabase>().addNote(noteControl.text);
                noteControl.clear();
                Navigator.pop(context);
            },
            child: Text('Create'),
          ),
          MaterialButton(
            onPressed: (){
                Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ));
  }

  void readNotes()
  {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNote(Note note)
  {
    noteControl.text = note.text;
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('U P D A T E'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
        content: TextField(
          controller: noteControl,
          
        ),
        actions: [
          MaterialButton(
            onPressed: (){
                context.read<NoteDatabase>().updateNote(note.id, noteControl.text);
                noteControl.clear();
                Navigator.pop(context);
            },
            child: Text('Update'),
          ),
          MaterialButton(
            onPressed: (){
                Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      )
      );
  }
  
  void deleteNote(int id)
  {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {

    final noteDB = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDB.currentNotes;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'N O T E S' , 
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w300,
          ),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNote();
        },
        child: const Icon(Icons.add),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context,index) 
          {
            final note = currentNotes[index];
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.white,
                title: Text(note.text),
                trailing:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                          onPressed: (){
                              updateNote(note);
                            }, 
                            icon: Icon(
                              Icons.edit_rounded,
                              color: Colors.black,),
                            ),
                    IconButton(
                      onPressed: (){
                        deleteNote(note.id);
                        }, 
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.black,),
                        ),
                  ],
                ),   
              ),
            );
          }
          ),

    );
  }
}