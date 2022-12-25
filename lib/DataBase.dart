import 'package:note/models/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseData {
  static Database? db;

  init() async {
    String documentDirectory = await getDatabasesPath();
    String path = join(documentDirectory, "notes.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE "note" (
            "id"	INTEGER NOT NULL,
            "title"	TEXT NOT NULL,
            "content"	TEXT NOT NULL,
            "color"	INTEGER NOT NULL,
            "date"	TEXT NOT NULL,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
        ''');
      },
    );
  }

  Future<Note> inerstNote(Note note) async {
    int id = await db!.insert("note", note.toMap());
    return Note.fromMap((await db!.query('note', where: 'id = ?', whereArgs: [id])).first);
  }

  Future<List<Note>> getNotes() async {
    List<Map<String, Object?>> queryResult = await db!.query('note');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> editNote(Note note) async {
    await db!.update('note', note.toMap() , where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    await db!.delete('note', where: 'id = ?', whereArgs: [id]);
  }

  closeBaseData() {
    db!.close();
  }
}
