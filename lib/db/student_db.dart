import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:student_management_system/model/student.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._init();

  static Database? _database;

  StudentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const studentTable = '''CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )''';

    await db.execute(studentTable);
  }



  Future<List<Student>> getStudents() async {
    final db = await instance.database;
    final result = await db.query('students');

    return result.map((json) => Student.fromMap(json)).toList();
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> createStudent(Student student) async {
    final db = await instance.database;

    // Insert the student into the database
    // The 'id' is optional as SQLite auto-increments it.
    final id = await db.insert(
      'students', // Table name
      student.toMap(), // Convert the student object to a map
      conflictAlgorithm: ConflictAlgorithm.replace, // To replace in case of conflict
    );

    return id; // Return the newly inserted student's id
  }}
