class FavoriteMoviesResponse {
  final List<FavoriteMovie> movies;

  FavoriteMoviesResponse({required this.movies});

  factory FavoriteMoviesResponse.fromJson(Map<String, dynamic> json) {
    var moviesFromJson = json['movies'] as List;
    List<FavoriteMovie> movieList = moviesFromJson
        .map((movie) => FavoriteMovie.fromJson(movie))
        .toList();
    
    return FavoriteMoviesResponse(movies: movieList);
  }
}

class FavoriteMovie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      posterUrl: json['posterUrl'],
    );
  }
}
