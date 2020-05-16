import 'package:Notes_final/Screens/notes_main.dart';
import 'package:Notes_final/Storage/notes_database.dart';
import 'package:Notes_final/Utils/groups.dart';
import 'package:Notes_final/Utils/notes.dart';
import 'package:Notes_final/Widgets/RemainderWidget.dart';
import 'package:Notes_final/main.dart';
import 'package:Notes_final/primaryValues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddNote extends StatefulWidget {
  final bool isEditNote;
  final Notes note;
  var dateTime;
  static List<DropdownMenuItem<dynamic>> dropDownitem = [];

  Group temp;
  bool groupCreated = false;
  bool groupItemUpdater = false;
  AddNote({Key key, this.isEditNote, this.note}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final SnackBar _snackBar = SnackBar(
    content: Text("Group already exist"),
    behavior: SnackBarBehavior.floating,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _groupName;
  TextEditingController noteTitle_controller = new TextEditingController();
  TextEditingController noteDescription_controller =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _notesDetailsFormKey = GlobalKey<FormState>();
  int _radioValue = 0;
  int _item = 2;
  String _noteTitle, _noteDescription;

  List<Group> group_list = [];

  List<MaterialColor> c = [Colors.green, Colors.yellow, Colors.red];
  List<String> color = ["Low", "Medium", "High"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (widget.groupCreated) {
                  notesDatabase.deleteGroup(widget.temp).then((value) {
                    Navigator.pop(context);
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            title: Text(
              widget.isEditNote ? "Edit Note" : "Add Note",
              style: AppTheme.title,
            ),
            actions: <Widget>[
              widget.isEditNote ? deleteButton() : Container(),
              saveButton(),
            ],
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
                future: _getGroupList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    AddNote.dropDownitem.clear();

                    createDropDownList(snapshot.data);

                    group_list = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        groupSelector(),
                        importance(),
                        notesDetails(),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          )),
    );
  }

  void createDropDownList(List<Group> groups) {
    for (int i = 1; i < groups.length; i++) {
      DropdownMenuItem<dynamic> item = DropdownMenuItem<dynamic>(
        child: Text(groups[i].name, style: AppTheme.subHeading),
        value: groups[i].id,
      );
      AddNote.dropDownitem.add(item);
    }
    DropdownMenuItem<dynamic> item = DropdownMenuItem<dynamic>(
      child: Text(
        "Add  Group",
        style: TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 0.5),
      ),
      value: -1,
    );
    AddNote.dropDownitem.add(item);
  }

  Widget deleteButton() {
    return Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: IconButton(
          icon: Icon(
            Icons.delete_forever,
            size: 28,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete Note"),
                    content: Text("Are you sure?"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            notesDatabase.deleteNote(widget.note).then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()));
                            });
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 16),
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  );
                });
          },
        ));
  }

  Widget saveButton() {
    return InkWell(
      onTap: () async {
        if (_notesDetailsFormKey.currentState.validate()) {
          _notesDetailsFormKey.currentState.save();
          var androidChannelSpecific =
              AndroidNotificationDetails("123", "MyNote", "sdsdsd");
          var iosChannelSpecific = IOSNotificationDetails();

          NotificationDetails platformSpecific =
              NotificationDetails(androidChannelSpecific, iosChannelSpecific);

          // var pending = await MyApp.flutterNotificationPlugin
          //     .pendingNotificationRequests();
          // print(pending);
          if (widget.isEditNote) {
            Notes note = widget.note;
            if (RemainderWidget.lights) {
              note.title = _noteTitle;
              note.description = _noteDescription;
              note.groupId = _item;
              note.dateReminder = RemainderWidget.dateTime.toString();
              note.priority = _radioValue;

              await MyApp.flutterNotificationPlugin.schedule(
                  note.id, note.title, note.description, RemainderWidget.dateTime, platformSpecific,payload: note.id.toString());
            } else {
              note.title = _noteTitle;
              note.description = _noteDescription;
              note.groupId = _item;
              note.dateReminder = "null";
              note.priority = _radioValue;
            }
            notesDatabase.updateNote(note).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            });
          } else {
            Notes note = new Notes(
                title: _noteTitle,
                description: _noteDescription,
                groupId: _item,
                dateReminder: RemainderWidget.dateTime.toString(),
                priority: _radioValue);

            notesDatabase.addNote(note).then((value) async {
              if (RemainderWidget.lights) {
                
                await MyApp.flutterNotificationPlugin.schedule(
                    value, note.title, note.description, RemainderWidget.dateTime, platformSpecific, payload: value.toString());
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.blue),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Text(
          "Save",
          style: TextStyle(
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.white,
              fontSize: 16),
        ),
      ),
    );
  }

  Widget groupSelector() {
    return Container(
      padding: EdgeInsets.all(20),
      height: 90,
      width: double.infinity,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Text(
                "Group Name :",
                style: AppTheme.heading,
              )),
          Expanded(
            child: DropdownButton(
              isExpanded: true,
              focusColor: Colors.lightBlueAccent,
              value: widget.groupItemUpdater ? group_list.length : _item,
              icon: Icon(
                Icons.arrow_drop_down,
                size: 28,
              ),
              items: AddNote.dropDownitem,
              onChanged: (value) {
                if (widget.groupItemUpdater) widget.groupItemUpdater = false;
                if (value == -1) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return addGroupPage();
                    },
                  );
                }
                setState(() {
                  if (value != -1)
                    _item = value;
                  else
                    _item = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addGroupPage() {
    return AlertDialog(
      title: Text("New Group Name"),
      content: Form(
          key: _formKey,
          child: TextFormField(
            style: AppTheme.subHeading,
            decoration: InputDecoration(
                labelText: "Group Name",
                labelStyle: AppTheme.heading,
                contentPadding: EdgeInsets.all(15)),
            validator: (value) {
              if (value.isEmpty) {
                return "Name can't be empty";
              }
              return null;
            },
            onSaved: (newValue) {
              _groupName = newValue;
            },
          )),
      actions: <Widget>[groupSaveButton(true), groupSaveButton(false)],
    );
  }

  Widget groupSaveButton(bool isSave) {
    return FlatButton(
        onPressed: () {
          bool groupExist = false;

          if (isSave) {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              for (int i = 0; i < group_list.length; i++) {
                if (_groupName == group_list[i].name) {
                  groupExist = true;
                  break;
                }
              }
              if (groupExist) {
                Navigator.pop(context);
                _scaffoldKey.currentState.showSnackBar(_snackBar);
              } else {
                widget.groupCreated = true;
                widget.groupItemUpdater = true;
                _item = group_list.length + 1;
                widget.temp = new Group(name: _groupName);
                notesDatabase.addGroup(widget.temp).then((value) {
                  setState(() {});
                });
                Navigator.of(context).pop();
              }
            }
          } else {
            Navigator.of(context).pop();
          }
        },
        child: Text(
          isSave ? "Save" : "Cancel",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ));
  }

  Widget notesDetails() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Form(
          key: _notesDetailsFormKey,
          child: Column(
            children: <Widget>[
              RemainderWidget(
                isEditNote: widget.isEditNote,
                note: widget.note,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: TextFormField(
                  style: AppTheme.heading,
                  controller: noteTitle_controller,
                  decoration: InputDecoration(
                      focusColor: Colors.blue,
                      hintText: "Title :",
                      hintStyle: AppTheme.heading),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Title  can't be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _noteTitle = newValue;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                        width: 0.3,
                        style: BorderStyle.solid,
                        color: Colors.black45)),
                child: TextFormField(
                  style: AppTheme.subHeading,
                  controller: noteDescription_controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Notes...",
                    hintStyle: AppTheme.heading,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Notes can't be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _noteDescription = newValue;
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget importance() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(
              left: 20,
            ),
            alignment: Alignment.centerLeft,
            child: Text("Importance", style: AppTheme.heading)),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < 3; ++i) radioButton(i, c[i], color[i])
            ],
          ),
        ),
      ],
    );
  }

  Widget radioButton(int value, MaterialColor color, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              value: value,
              groupValue: _radioValue,
              activeColor: color,
              onChanged: (value) {
                setState(() {
                  _radioValue = value;
                });
              }),
          Text(
            text,
            style: AppTheme.notesDescription,
          )
        ],
      ),
    );
  }

  _getGroupList() {
    Future<List<Group>> group = notesDatabase.getListGroup();
    return group;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditNote) {
      _item = widget.note.groupId;
      _radioValue = widget.note.priority;
      noteTitle_controller.value = TextEditingValue(text: widget.note.title);
      noteDescription_controller.value =
          TextEditingValue(text: widget.note.description);
    }
  }
}
