import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesappflutter/model/note.dart';
import 'package:notesappflutter/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {

  DatabaseHelper helper  = DatabaseHelper();

  String appBartitle;
  Note note;
  NoteDetailState(this.note,this.appBartitle);

  static var _priorities = ["High", "Low"];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titlecontroller.text = note.title;
    descriptioncontroller.text = note.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(appBartitle),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityasString(note.priority),
                  onChanged: (valueSelectedbyUser) {
                    setState(() {
                      updatePriorityasInt(valueSelectedbyUser);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                child: TextField(
                  controller: titlecontroller,
                  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                child: TextField(
                  controller: descriptioncontroller,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text("Save", textScaleFactor: 1.5,),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    )),
                    Container(width: 5.0),
                    Expanded(
                        child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                        "Delete",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void updatePriorityasInt(String value)
  {
    switch(value)
    {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }
  String getPriorityasString(int value)
  {
    String priority;
    switch(value)
    {
      case 1:
        priority = _priorities[0];
        break;

      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle()
  {
    if(titlecontroller.text == null)
      {
        final snackbar = SnackBar(content: Text("Enter valid title"));
        Scaffold.of(context).showSnackBar(snackbar);
      }
    else {
      note.title = titlecontroller.text;
    }
  }
  void updateDescription()
  {
    note.description = descriptioncontroller.text;
  }

  void _save() async {

      Navigator.pop(context, true);

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }
  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  void _delete() async {

    Navigator.pop(context, true);

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }


}
