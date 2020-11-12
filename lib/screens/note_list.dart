import 'package:flutter/material.dart';
import 'package:notesappflutter/screens/note_detail.dart';
import 'package:notesappflutter/utils/database_helper.dart';
import 'package:notesappflutter/model/note.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> notelist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (notelist == null) {
      notelist = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NotesApp"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          navigatetoNoteDetail(Note(" " ," ",2),"Add Note");
        },
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(notelist[position].priority),
              child: getPriorityIcon(notelist[position].priority),
            ),
            title: Text(notelist[position].title, style: textStyle),
            subtitle: Text(notelist[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.deepOrangeAccent),
              onTap: () {
                _delete(context, notelist[position]);
              },
            ),
            onTap: () {
              navigatetoNoteDetail(this.notelist[position],"Edit List");
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.red;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note deleted successfully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackbar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void navigatetoNoteDetail(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note,title);
    }));

    if(result == true)
      updateListView();

  }

  void updateListView() {
    
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((notelist) {
        setState(() {
          this.notelist = notelist;
          this.count = notelist.length;
        });
      });

    });
    
  }
}
