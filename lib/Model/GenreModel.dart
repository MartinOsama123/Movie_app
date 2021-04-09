class GenreModel {
  Map<int,String> genres;

  GenreModel({this.genres});

  GenreModel.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = Map();
      json['genres'].forEach((v) {
        Genres g = new Genres.fromJson(v);
        genres[g.id] = g.name;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genres != null) {
      data['genres'] = this.genres;
    }
    return data;
  }
}

class Genres {
  int id;
  String name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}