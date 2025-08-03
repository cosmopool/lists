import "package:flutter_test/flutter_test.dart";
import "package:lists/database/database.dart";
import "package:lists/database/utils.dart";
import "package:lists/entities/task.dart";
import "package:sqlite3/sqlite3.dart";

void main() {
  late Database database;

  setUp(() {
    database = sqlite3.openInMemory();
    TasksDatabase.init(database);
  });

  tearDown(TasksDatabase.dispose);

  test("should succefully add task when fields are valid", () {
    final task = Task(id: "id", title: "test title", completed: false);

    TasksDatabase.saveTasks([task]);

    const query = "SELECT * FROM tasks";
    final ResultSet resultSet = database.select(query);
    final Row? row = resultSet.firstOrNull;
    expect(row, isNotNull);
    expect(row?["title"], task.title);
    expect(row?["completed"], task.completed.toDatabase);
  });
}
