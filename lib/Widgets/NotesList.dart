import 'package:Notes_final/Screens/add_edit_Note.dart';
import 'package:Notes_final/Storage/notes_database.dart';
import 'package:Notes_final/Utils/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../primaryValues.dart';

class NotesList extends StatefulWidget {
  final int groupno;

  NotesList({Key key, this.groupno}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  Future<List<Notes>> noteList;
  List<Notes> groupwiseNoteList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // for(int i=0;i<snapshot.data.length;i++) {
            //   print("ID: ${snapshot.data[i].id}, name : ${snapshot.data[i].title}");
            // }
            if (widget.groupno != 0) {
              for (int i = 0; i < snapshot.data.length; ++i) {
                if (widget.groupno + 1 == snapshot.data[i].groupId)
                  groupwiseNoteList.add(snapshot.data[i]);
              }
            } else {
              groupwiseNoteList = snapshot.data;
            }
            return Container(
              child: Scrollable(viewportBuilder: (_, __) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: groupwiseNoteList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      new Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNote(
                                isEditNote: true,
                                note: groupwiseNoteList[index])));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 6, right: 6),
                              padding: EdgeInsets.only(left: 10),
                              height: 50,
                              width: 210,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      groupwiseNoteList[index].title,
                                      style: AppTheme.notesTitle,
                                    ),
                                  ),
                                  Container(
                                    margin: (EdgeInsets.all(10.0)),
                                    child:
                                        groupwiseNoteList[index].dateReminder !=
                                                "null"
                                            ? Icon(
                                                Icons.add_alert,
                                                color: Colors.black38,
                                                size: 15,
                                              )
                                            : null,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: groupwiseNoteList[index]
                                                  .priority ==
                                              0
                                          ? Text(
                                              "!",
                                              style: TextStyle(
                                                  fontFamily: 'WorkSans',
                                                  color: Colors.green[500],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            )
                                          : groupwiseNoteList[index].priority ==
                                                  1
                                              ? Text(
                                                  "!!",
                                                  style: TextStyle(
                                                      fontFamily: 'WorkSans',
                                                      color: Colors.yellow[100],
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5),
                                                )
                                              : Text("!!!",
                                                  style: TextStyle(
                                                      fontFamily: 'WorkSans',
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5))),
                                ],
                              ),
                              color: Color.fromRGBO(255, 170, 29, 1)),
                          groupwiseNoteList[index].dateReminder != "null"
                              ? Container(
                                  color: Color.fromRGBO(255, 255, 80, 1),
                                  margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
                                  padding: EdgeInsets.only(
                                      left: 10, top: 6, bottom: 0),
                                  width: 210,
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: groupwiseNoteList[index]
                                              .dateReminder
                                              .substring(0, 10)),
                                      TextSpan(text: "\n"),
                                      TextSpan(
                                          text: groupwiseNoteList[index]
                                              .dateReminder
                                              .substring(11, 16))
                                    ], style: AppTheme.notesDate),
                                  ),
                                )
                              : Container(),
                          Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 6, right: 6),
                              width: 210,
                              child: Text(
                                groupwiseNoteList[index].description,
                                style: AppTheme.notesDescription,
                              ),
                              color: Color.fromRGBO(255, 255, 80, 1)),
                        ],
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 6.0,
                  crossAxisSpacing: 6.0,
                );
              }),
            );
          } else {
            return Container();
          }
        });
  }

  _getNoteList() {
    Future<List<Notes>> notes = notesDatabase.getListNote();
    return notes;
  }
}
