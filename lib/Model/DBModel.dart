import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movie_app/Model/MovieModel.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Favorite with ChangeNotifier {
  final int id;
  final String name, imageUrl;
  final double averageVote;

  Favorite({this.id, this.name, this.imageUrl, this.averageVote});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'image': imageUrl, 'average': averageVote};
  }

  static Future<Database> database;
   Future<void> insertDog(Favorite favorite) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'likes',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

 static Future<void> createDB() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'likes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE likes(id INTEGER PRIMARY KEY, name TEXT, image TEXT, average INTEGER)",
        );
      },
      version: 1,
    );
  }

   Future<List<Favorite>> favorites() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('likes');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Favorite(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imageUrl: maps[i]['image'],
          averageVote: maps[i]['average']);
    });
  }

   Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the Database.
    await db.delete(
      'likes',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    notifyListeners();
  }
}
