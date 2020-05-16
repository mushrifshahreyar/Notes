import 'package:Notes_final/Utils/groups.dart';
import 'package:Notes_final/Utils/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  Database _database;
  static NotesDatabase _notesDatabase;
  NotesDatabase._createInstance();

  factory NotesDatabase() {
    if (_notesDatabase == null) {
      _notesDatabase = NotesDatabase._createInstance();
    }
    return _notesDatabase;
  }

  Future<Database> get database async {
    if (_database != null) {
      
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  String _tableName = 'Notes';
  String _tableNameGroup = 'Groups';

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "Note.db");
    // await deleteDatabase(path);
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("""
          CREATE TABLE Notes
          (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT,
            groupid INTEGER,
            priority INTEGER  
          )
       """);
        await db.execute("""
        CREATE TABLE Groups
        (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      """);

        await db.insert(_tableNameGroup, group0.toMap(),conflictAlgorithm: ConflictAlgorithm.abort);

        await db.insert(_tableNameGroup, group1.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
      },
    );
    return db;
  }

  Future<int> addNote(Notes note) async {
    Database db = await this.database;
    Future<int> result = db.insert(_tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> addGroup(Group group) async {
    Database db = await this.database;
    Future<int> result = db.insert(_tableNameGroup, group.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return result;
  }

  Group group0 = new Group(id:0,name: "All");
  Group group1 = new Group(name: "Others");

  Future<int> updateNote(Notes note) async {
    Database db = await this.database;
    Future<int> result = db.update(_tableName, note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Notes note) async {
    Database db = await this.database;
    Future<int> result =
        db.delete(_tableName, where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteGroup(Group group) async {
    Database db = await this.database;
    Future<int> result =
        db.delete(_tableNameGroup, where: 'name = ?', whereArgs: [group.name]);
    return result;
  }

  Future<List<Notes>> getListNote() async {
    Database db = await this.database;
    List<Map<String, dynamic>> listNotes =
        await db.query(_tableName, orderBy: 'priority ASC');
    List<Notes> notes = [];
    for (int i = 0; i < listNotes.length; ++i) {
      notes.add(Notes.fromMap(listNotes[i]));
    }
    return notes;
  }

  Future<List<Group>> getListGroup() async {
    Database db = await this.database;
    List<Map<String, dynamic>> listGroups = await db.query(_tableNameGroup);
    List<Group> groups = [];
    for (int i = 0; i < listGroups.length; ++i) {
      groups.add(Group.fromMap(listGroups[i]));
    }
    return groups;
  }

  
}

final NotesDatabase notesDatabase = NotesDatabase();