
import 'dart:convert';

import 'package:movie_app/Model/MovieModel.dart';
import 'package:http/http.dart' as http;
class Data {
  static const IP_ADDRESS = "https://api.themoviedb.org/3/movie";
  static const API = "api_key=3341631117f8da98766219dfd5703269";

  static Future<List<Results>> getNowPlaying({int page = 1}) async {
    MovieModel movieModel;

    var response = await http.get(
        Uri.parse("$IP_ADDRESS/now_playing?$API&page=$page"));
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
        Uri.parse("$IP_ADDRESS/top_rated?$API&page=$page"));
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
    print("Finsihed");
    return movieModel.results;
  }
}