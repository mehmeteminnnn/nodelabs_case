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

  Future<void> toggleFavorite(String filmId) async {
    // Favori işlemi için mevcut API'ye göre güncelleme gerekebilir.
  }

  Future<List<FilmModel>> fetchFavoriteFilms() async {
    // Favori filmler için mevcut API'ye göre güncelleme gerekebilir.
    return [];
  }
}
