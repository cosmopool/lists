import "package:sqlite3/sqlite3.dart";

abstract class TasksDatabase {
  static Database? db;

  static String name = "tasks_database";

  static void init() {
    db = sqlite3.open(name);

    db?.execute("""
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      completed INTEGER NOT NULL
    );
  """);

    db?.execute("""
    CREATE TABLE IF NOT EXISTS weblinks (
      id INTEGER NOT NULL PRIMARY KEY,
      url TEXT NOT NULL
    );
  """);

    db?.execute("""
    CREATE TABLE IF NOT EXISTS images (
      id INTEGER NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      binary BLOB NOT NULL
    );
  """);

    db?.execute("""
    CREATE TABLE IF NOT EXISTS audios (
      id INTEGER NOT NULL PRIMARY KEY,
      path TEXT NOT NULL,
      length INTEGER NOT NULL
    );
  """);
  }

  static void dispose() {
    db?.dispose();
  }
}
