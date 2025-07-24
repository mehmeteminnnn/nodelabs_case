import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_service.dart';
import '../bloc/auth_bloc.dart';
import 'dart:io';

class UploadProfilePhotoScreen extends StatefulWidget {
  const UploadProfilePhotoScreen({super.key});

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;
    setState(() {
      _isLoading = true;
    });
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.currentUser;
    if (user == null || user.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı oturumu bulunamadı.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final apiService = ApiService();
    final response = await apiService.uploadProfilePhoto(
      _selectedImage!.path,
      user.token!,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf başarıyla yüklendi.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Yükleme başarısız.')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profil Detayı',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Fotoğraflarınızı Yükleyin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: _pickImage,
                child:
                    _selectedImage == null
                        ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white54,
                              size: 48,
                            ),
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _uploadPhoto,
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Devam Et',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
