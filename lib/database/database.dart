import "package:lists/entities/task.dart";
import "package:sqlite3/sqlite3.dart";

typedef _Batch = List<String>;

abstract class TasksDatabase {
  static Database? db;

  static String name = "tasks_database";

  static void init([Database? openedDb]) {
    db = openedDb ?? sqlite3.open(name);

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

  static _Batch _beginBatch() => <String>["BEGIN"];
  static void _executeBatch(_Batch batch) {
    assert(db != null, "db must be initialized");
    assert(batch.isNotEmpty, "no empty batch should be executed");
    assert(batch.first == "BEGIN", "batch should start with 'BEGIN'");
    assert(batch.length >= 2, "batch should contains SQL queries too");

    batch.add("COMMIT;");
    final String sql = batch.join("; ");
    return db?.execute(sql);
  }

  static void saveTasks(List<Task> tasks) {
    assert(db != null, "db must be initialized");

    final _Batch batch = _beginBatch();
    for (final Task task in tasks) {
      batch.add(
        """INSERT INTO tasks (title, completed) VALUES ('${task.title}', ${task.completed})""",
      );
    }
    return _executeBatch(batch);
  }

  static void dispose() {
    db?.dispose();
  }
}
