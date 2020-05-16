import 'package:Notes_final/Storage/notes_database.dart';

class Group {
  int id;
  String name;

  Group({this.id, this.name});

  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = Map<String,dynamic>();
    map['name'] = name; 
    
    return map;
  }

  Group.fromMap(Map<String,dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

}