import 'package:flutter/material.dart';
import 'package:notesappflutter/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NotesApp"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          navigatetoNoteDetail("Add List");
        },
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context,int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right_outlined),
            ),
            title: Text("Dummy title"),
            subtitle: Text("Dummy date"),
            trailing: Icon(Icons.delete,color: Colors.deepOrangeAccent),
            onTap: (){
              navigatetoNoteDetail("Edit List");
            },
          ),
        );
      },
    );
  }

  void navigatetoNoteDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder:(context){
      return NoteDetail(title);
    }));
  }

}
