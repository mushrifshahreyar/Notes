import 'package:Notes_final/Screens/notes_main.dart';
import 'package:Notes_final/Utils/groups.dart';
import 'package:Notes_final/Widgets/NotesList.dart';
import 'package:Notes_final/primaryValues.dart';
import 'package:flutter/material.dart';

class GroupListWidget extends StatefulWidget {
  static int selectedIndex;
  final List<Group> groupList;
  static ScrollController scrollController;
  GroupListWidget({Key key, this.groupList}) : super(key: key);
  
  @override
  _GroupListWidgetState createState() => _GroupListWidgetState();
}

class _GroupListWidgetState extends State<GroupListWidget> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          controller: GroupListWidget.scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.groupList.length,
          itemBuilder: (context, index) {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              enableFeedback: true,
              onTap: () {
                
                setState(() {
                  GroupListWidget.selectedIndex = index;
                  MainScreen.pageController.animateToPage(GroupListWidget.selectedIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: GroupListWidget.selectedIndex == index
                        ? Border.all(style: BorderStyle.none)
                        : Border.all(
                            color: Colors.black, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50),
                    color:
                        GroupListWidget.selectedIndex == index ? Colors.blue : Colors.white),
                width: 90,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 5),
                child: Text(
                  widget.groupList[index].name,
                  style: GroupListWidget.selectedIndex == index
                      ? AppTheme.display_group_2
                      : AppTheme.display_group_1,
                ),
              ),
            );
          });

  }
  
  @override
  void initState() { 
    super.initState();
    GroupListWidget.selectedIndex = 0;
    GroupListWidget.scrollController = ScrollController(initialScrollOffset: 0,keepScrollOffset: true);
  }
}