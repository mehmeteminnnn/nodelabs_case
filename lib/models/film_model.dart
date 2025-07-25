class FilmModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  FilmModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id'] ?? json['_id'],
      title: json['Title'] ?? '',
      description: json['Plot'] ?? '',
      posterUrl: json['Poster'] ?? '',
    );
  }
}
