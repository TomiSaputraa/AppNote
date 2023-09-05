import 'package:note_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

// mengecek database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('notes.db');
    return _database!;
  }

// inisialisasi database
  Future<Database> _initDB(String filePath) async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

// membuat kolum database
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteField.id} $idType, 
  ${NoteField.isImportant} $boolType,
  ${NoteField.number} $integerType,
  ${NoteField.title} $textType,
  ${NoteField.description} $textType,
  ${NoteField.time} $textType
  )
''');
  }

// CREATE
  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

// READ by id
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteField.values,
      where: '${NoteField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

// READ
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${NoteField.time} ASC';
    // contoh query sql manual
    // final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

// UPDATE
  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteField.id} = ?',
      whereArgs: [note.id],
    );
  }

// DELETE
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteField.id} = ?',
      whereArgs: [id],
    );
  }

  // Tambahkan fungsi pencarian data
  Future<List<Map<String, dynamic>>> search(String query) async {
    final Database db = await database;
    return await db.query(
      tableNotes,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
