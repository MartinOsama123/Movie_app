class MovieModel {

  var page;
  List<Results> results;

  MovieModel(
      {
        this.page,
        this.results});

  MovieModel.fromJson(Map<String, dynamic> json) {

    page = json['page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Results {
  var _backdropPath;
  get backdropPath => "https://image.tmdb.org/t/p/w780/$_backdropPath";
  List<int> genreIds;
  var id;
  var originalTitle;
  var overview;
  var voteAverage;
  var voteCount;

  Results(
      {
        this.genreIds,
        this.id,
        this.originalTitle,
        this.overview,
        this.voteAverage,
        this.voteCount});


  Results.fromJson(Map<String, dynamic> json) {

    _backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];

    originalTitle = json['original_title'];
    overview = json['overview'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['backdrop_path'] = this._backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;

    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }

}