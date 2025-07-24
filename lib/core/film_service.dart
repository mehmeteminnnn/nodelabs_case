import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film_model.dart';
import 'api_service.dart';

class FilmService {
  final ApiService apiService;
  FilmService(this.apiService);

  Future<List<FilmModel>> fetchFilms(int page) async {
    final response = await apiService.post('/movie/list', {'page': page});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['movies'];
      return data.map((e) => FilmModel.fromJson(e)).toList();
    } else {
      throw Exception('Film listesi alınamadı');
    }
  }

  Future<void> toggleFavorite(int filmId) async {
    final response = await apiService.post('/movie/favorite', {
      'movie_id': filmId,
    });
    if (response.statusCode != 200) {
      throw Exception('Favori işlemi başarısız');
    }
  }

  Future<List<FilmModel>> fetchFavoriteFilms() async {
    final response = await apiService.post('/movie/favorites', {});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['movies'];
      return data.map((e) => FilmModel.fromJson(e)).toList();
    } else {
      throw Exception('Favori filmler alınamadı');
    }
  }
}
