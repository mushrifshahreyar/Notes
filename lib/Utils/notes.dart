class Notes {
  int id, groupId;
  String title, description;
  String dateReminder;
  int priority;
  Notes(
      {this.id,
      this.groupId,
      this.title,
      this.description,
      this.dateReminder,
      this.priority});

  Map<String,dynamic> toMap() {
    Map<String,dynamic> map = Map<String,dynamic>();
    map['title'] = title; 
    map['description'] = description;
    map['date'] = dateReminder.toString();
    map['groupid'] = groupId;
    map['priority'] = priority;

    return map;
  }

  factory Notes.fromMap(Map<String,dynamic> map) {
    Notes note = new Notes(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateReminder: map['date'],
      groupId: map['groupid'],
      priority: map['priority']
    );
    return note;
  }
}