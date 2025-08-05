import "dart:mirrors";
import "dart:typed_data";

import "package:core/src/database/database.dart";
import "package:core/src/database/utils.dart";
import "package:core/src/entities/task.dart";
import "package:sqlite3/sqlite3.dart";
import "package:test/test.dart";

void main() {
  late Database database;

  setUp(() {
    database = sqlite3.openInMemory();
    TasksDatabase.init(database);
  });

  tearDown(TasksDatabase.dispose);

  test("should successfully add task when fields are valid", () {
    final task = Task(id: "id", title: "test title", completed: false);

    TasksDatabase.saveTasks([task]);

    const query = "SELECT * FROM tasks";
    final ResultSet resultSet = database.select(query);
    final Row? row = resultSet.firstOrNull;
    expect(row, isNotNull);
    expect(row?["title"], task.title);
    expect(row?["completed"], task.completed.toDatabase);
  });

  test("db table schema should maintain parity with Task class interface", () {
    final ignoredMembers = <String>["id", "parentId"];
    final task = Task(id: "id", title: "test title", completed: false);

    final ResultSet resultSet = database.select("PRAGMA table_info(tasks);");
    final InstanceMirror taskMirror = reflect(task);

    for (final Symbol instanceMember in taskMirror.type.instanceMembers.keys) {
      final String member = symbolName(instanceMember);
      if (member == "Task") continue;
      if (member == "==") continue;
      if (member == "hashCode") continue;
      if (member == "toString") continue;
      if (member == "noSuchMethod") continue;
      if (member == "runtimeType") continue;
      if (member.endsWith("=")) continue;
      if (ignoredMembers.contains(member)) continue;

      final Row? row = firstWhereOrNull(
        resultSet,
        (Row row) => row["name"] == member,
      );
      expect(row, isNotNull);
      expect(row!["type"], isA<String>());

      final InstanceMirror memberMirror = taskMirror.getField(instanceMember);
      expect(
        row["type"].toString().toUpperCase(),
        typeDartToSqlite(memberMirror.type.reflectedType),
      );
    }
  });
}

String symbolName(Symbol symbol) =>
    symbol.toString().replaceFirst("Symbol(\"", "").replaceFirst("\")", "");

T? firstWhereOrNull<T>(Iterable<T> iterable, bool Function(T) test) {
  try {
    return iterable.firstWhere(test);
  } catch (e) {
    return null;
  }
}

// String symbolToSqlite(Symbol symbol) {
//   final String typeName = symbolName(symbol);
//   return switch (typeName) {
//     "String" || "_OneByteString" => "TEXT",
//     "int" => "INTEGER",
//     "double" => "REAL",
//     "Uint8List" => "BLOB",
//     _ => throw UnimplementedError("Not implemented for $type type"),
//   };
// }

String typeDartToSqlite(Type type) {
  if (type is String) return "TEXT";
  if (type is int) return "INTEGER";
  if (type is double) return "REAL";
  if (type is Uint8List) return "BLOB";
  throw UnimplementedError("Not implemented for $type type");
}

// String typeDartToSqlite(Type type) => switch (type) {
//   const (String) => "TEXT",
//   const (int) => "INTEGER",
//   const (double) => "REAL",
//   const (Uint8List) => "BLOB",
//   _ => throw UnimplementedError("Not implemented for $type type"),
// };
