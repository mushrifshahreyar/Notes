import 'package:Notes_final/Screens/add_edit_Note.dart';
import 'package:Notes_final/Storage/notes_database.dart';
import 'package:Notes_final/Utils/groups.dart';
import 'package:Notes_final/Widgets/GrouplistWidget.dart';
import 'package:Notes_final/Widgets/NotesList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../primaryValues.dart';

class MainScreen extends StatefulWidget {
  static PageController pageController;
  MainScreen({Key key}) : super(key: key);
  static List<Widget> notePageList = [];
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Group>> groupList;

  void initState() {
    super.initState();
    MainScreen.pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
      keepPage: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            "Notes",
            style: AppTheme.title,
          ),
        ),
        body: FutureBuilder(
            future: _getGroupList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MainScreen.notePageList.clear();
                for (int i = 0; i < snapshot.data.length; ++i) {
                  MainScreen.notePageList.add(new NotesList(
                    groupno: i,
                  ));
                }
                return Column(
                  children: <Widget>[
                    groupDisplay(snapshot.data),
                    Divider(
                      thickness: 1,
                      color: Colors.black12,
                    ),
                    noteListDisplay(snapshot.data),
                  ],
                );
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            }),
        floatingActionButton: addButton(),
      ),
    );
  }

  Widget addButton() {
    return Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNote(
                  isEditNote: false,
                ),
              ));
            },
            child: Icon(
              Icons.add,
              size: 25,
            )));
  }

  Widget noteListDisplay(List<Group> groups) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.all(6),
      child: PageView(
          physics: ClampingScrollPhysics(),
          controller: MainScreen.pageController,
          onPageChanged: (value) {
            setState(() {
              GroupListWidget.scrollController.animateTo(
                  (value * 100).toDouble(),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeIn);
              
              GroupListWidget.selectedIndex = value;
            });
          },
          children: MainScreen.notePageList),
    ));
  }

  Widget groupDisplay(List<Group> groups) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      height: 35,
      child: GroupListWidget(groupList: groups),
    );
  }

  _getGroupList() {
    Future<List<Group>> groups = notesDatabase.getListGroup();
    return groups;
  }
}
