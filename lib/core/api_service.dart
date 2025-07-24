import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.StreamedResponse> uploadProfilePhoto(
    String filePath,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/profile/upload-photo');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    return await request.send();
  }
}
