import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class UploadPhotoSheet extends StatefulWidget {
  final Function(String) onPhotoUploaded;

  const UploadPhotoSheet({Key? key, required this.onPhotoUploaded}) : super(key: key);

  @override
  _UploadPhotoSheetState createState() => _UploadPhotoSheetState();
}

class _UploadPhotoSheetState extends State<UploadPhotoSheet> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fotoğraf seçilirken hata oluştu: $e';
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // AuthBloc'tan token'ı al
      final authBloc = context.read<AuthBloc>();
      final token = authBloc.state is AuthSuccess
          ? (authBloc.state as AuthSuccess).user.token
          : null;

      if (token == null) {
        throw Exception('Kullanıcı girişi yapılmamış.');
      }

      final url = Uri.parse('https://caseapi.servicelabs.tech/user/upload_photo');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      final file = _selectedImage!;
      final fileName = path.basename(file.path);
      final fileExtension = path.extension(fileName).toLowerCase();

      final contentType = fileExtension == '.png'
          ? MediaType('image', 'png')
          : fileExtension == '.jpg' || fileExtension == '.jpeg'
              ? MediaType('image', 'jpeg')
              : MediaType('image', '*');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: contentType,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final photoUrl = responseData['photoUrl'];
        if (photoUrl != null) {
          widget.onPhotoUploaded(photoUrl);
          Navigator.pop(context);
        } else {
          throw Exception('Geçersiz yanıt formatı.');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Geçersiz dosya formatı.');
      } else if (response.statusCode == 401) {
        throw Exception('Yetkisiz erişim. Lütfen tekrar giriş yapın.');
      } else {
        throw Exception('Fotoğraf yüklenirken bir hata oluştu (${response.statusCode}).');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka plan siyah
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profil Detayı', style: TextStyle(color: Colors.white,fontSize: 15)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Fotoğraflarınızı Yükleyin',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Resources out incentivize\nrelaxation floor loss cc.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage == null
                    ? const Icon(Icons.add, color: Colors.white, size: 32)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedImage == null || _isLoading ? null : _uploadPhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Devam Et',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
