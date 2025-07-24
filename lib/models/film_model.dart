class FilmModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isFavorite;

  FilmModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory FilmModel.fromJson(Map<String, dynamic> json) {
    return FilmModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}
