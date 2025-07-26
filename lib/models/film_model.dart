class FilmModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  bool isFavorite;

  FilmModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
  });

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id'] ?? json['_id'],
      title: json['Title'] ?? '',
      description: json['Plot'] ?? '',
      posterUrl: json['Poster'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  FilmModel copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
  }) {
    return FilmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
