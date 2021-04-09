
import 'dart:convert';

import 'package:movie_app/Model/GenreModel.dart';
import 'package:movie_app/Model/MovieModel.dart';
import 'package:http/http.dart' as http;
class Data {
  static const IP_ADDRESS = "https://api.themoviedb.org/3";
  static const API = "api_key=3341631117f8da98766219dfd5703269";

  static Future<List<Results>> getNowPlaying({int page = 1}) async {
    MovieModel movieModel;

    var response = await http.get(
        Uri.parse("$IP_ADDRESS/movie/now_playing?$API&language=en-US&page=$page"));
    if (response != null && response.statusCode == 200) {
      try {
        movieModel = MovieModel.fromJson(jsonDecode(response.body));
      } catch (e) {
        print(e.toString());
      }
    }
    print("Finsihed");
    print("$IP_ADDRESS/now_playing?$API&page=$page");
    return movieModel.results;
  }
  static Future<List<Results>> getTopRated({int page = 1}) async {
    MovieModel movieModel;

    var response = await http.get(
        Uri.parse("$IP_ADDRESS/movie/top_rated?$API&language=en-US&page=$page"));
    if (response != null && response.statusCode == 200) {
      try {
        movieModel = MovieModel.fromJson(jsonDecode(response.body));
      } catch (e) {
        print(e.toString());
      }
    }
    print("Finsihed");
    return movieModel.results;
  }
  static Future<List<Results>> searchMovies({String query="",int page = 1}) async {
    MovieModel movieModel;

    var response = await http.get(
        Uri.parse("$IP_ADDRESS/search/movie?query=$query&$API&page=$page"));
    if (response != null && response.statusCode == 200) {
      try {
        movieModel = MovieModel.fromJson(jsonDecode(response.body));
      } catch (e) {
        print(e.toString());
      }
    }
    print("$IP_ADDRESS/search/movie?query=$query&$API&page=$page");
    return movieModel.results;
  }

  static Future<Map<int,String>> getGenres() async {
    GenreModel genreModel;
    print("$IP_ADDRESS/genre/movie/list?$API");
    var response = await http.get(
        Uri.parse("https://api.themoviedb.org/3/genre/movie/list?$API"));
    if (response != null && response.statusCode == 200) {
      try {
        genreModel = GenreModel.fromJson(jsonDecode(response.body));
      } catch (e) {
        print(e.toString());
      }
    }


    return genreModel.genres;
  }
}