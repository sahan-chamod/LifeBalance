import 'package:life_balance/db/allergicModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'lifeBalance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicalAllergic (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE foodAllergic (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertMedicalAllergic(Allergic allergic) async {
    final db = await database;
    await db.insert(
      "medicalAllergic",
      {
        "title": allergic.title,
        "description": allergic.description,
        "created": allergic.created.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
    );
  }

  Future<void> insertFoodAllergy(Allergic allergic) async {
    final db = await database;
    await db.insert(
      "foodAllergic",
      {
        "title": allergic.title,
        "description": allergic.description,
        "created": allergic.created.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
    );
  }

  Future<List<Allergic>> getMedicalAllergic() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("medicalAllergic");

    return maps.map((map) {
      return Allergic(
        title: map['title'] as String,
        description: map['description'] as String,
        created: DateTime.parse(map['created'] as String),
      );
    }).toList();
  }

  Future<List<Allergic>> getFoodAllergies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("foodAllergic");

    return maps.map((map) {
      return Allergic(
        title: map['title'] as String,
        description: map['description'] as String,
        created: DateTime.parse(map['created'] as String),
      );
    }).toList();
  }
}
