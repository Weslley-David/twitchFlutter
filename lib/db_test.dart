//this file isnt working, please, ignore it.
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'daily_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dailypage(id INTEGER PRIMARY KEY, title VARCHAR, content TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(DailyPage dailyPage) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dailyPage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<DailyPage>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dailypage');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DailyPage(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(DailyPage dailyPage) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dailypage',
      dailyPage.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dailyPage.id],
    );
  }

  Future<void> deleteDailyPage(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dailypage',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = const DailyPage(
    id: 0,
    title: 'Sad Day',
    content: 'albion online foi um mmo rpg sandbox que me deixou triste',
    age: 14,
  );
 var dido = const DailyPage(
    id: 1,
    title: 'Happy Day',
    content: 'albion online é um mmo rpg sandbox que me deixou feliz',
    age: 15,
  );
  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = DailyPage(
    id: fido.id,
    title: fido.title,
    content: fido.content,
    age: fido.age,
  );
  await updateDog(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDailyPage(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}

class DailyPage {
  final int id;
  final String title;
  final String content;
  final int age;

  const DailyPage({
    required this.id,
    required this.title,
    required this.content,
    required this.age,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'DailyPage{id: $id,title: $title, content: $content, age: $age}';
  }
}
