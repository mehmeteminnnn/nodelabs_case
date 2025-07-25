import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film_model.dart';
import 'api_service.dart';

class FilmService {
  final ApiService apiService;
  FilmService(this.apiService);

  Future<List<FilmModel>> fetchFilms(int page, String token) async {
    final url = Uri.parse('${ApiService.baseUrl}/movie/list?page=$page');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('Film listesi statusCode:  [33m${response.statusCode} [0m');
    print('Film listesi body: ${response.body}');
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data']?['movies'] ?? [];
      return data.map((e) => FilmModel.fromJson(e)).toList();
    } else {
      throw Exception('Film listesi alınamadı');
    }
  }
   Future<List<FilmModel>> fetchFavoriteFilms(String token) async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/movie/favorites'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['movies'] ?? [];
      return movies.map((movie) => FilmModel.fromJson(movie)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Yetkisiz erişim. Lütfen tekrar giriş yapın.');
    } else {
      throw Exception('Favori filmler alınamadı. Hata kodu: ${response.statusCode}');
    }
  }

  /*Future<void> toggleFavorite(String filmId) async {
    // Favori işlemi için mevcut API'ye göre güncelleme gerekebilir.
  }*/
}
