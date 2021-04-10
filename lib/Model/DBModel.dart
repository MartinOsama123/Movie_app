import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:movie_app/Model/MovieModel.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Favorite with ChangeNotifier {
  final int id;
  final String name, imageUrl;
  final double averageVote;
  final Results results;

  Favorite({this.id, this.name, this.imageUrl, this.averageVote,this.results});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'image': imageUrl, 'average': averageVote};
  }

  static Future<Database> database;
   Future<void> insertFavorite(Favorite favorite) async {

    final Database db = await database;

    print(favorite.toMap());
    await db.insert(
      'likes',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(favorite.results);
    notifyListeners();
  }

 static Future<void> createDB() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'likes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE likes(uid INTEGER PRIMARY KEY, id INTEGER , name TEXT, image TEXT, average DOUBLE)",
        );
      },
      version: 2,
    );
  }

   Future<List<Favorite>> favorites() async {
    // Get a reference to the database.
    final Database db = await database;


    final List<Map<String, dynamic>> maps = await db.query('likes');

    return List.generate(maps.length, (i) {
      return Favorite(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imageUrl: maps[i]['image'],
          averageVote: maps[i]['average']);
    }).reversed.toList();
  }

   Future<void> deleteFavorite(int id) async {

    final db = await database;

    await db.delete(
      'likes',
      where: "id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }
}
