import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs_case/screens/limited_offer_screen.dart';
import '../bloc/film_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/settings_cubit.dart';
import '../models/film_model.dart';
import 'upload_photo_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Theme options
  final List<Map<String, dynamic>> _themes = [
    {
      'mode': ThemeMode.system,
      'name': 'Sistem Teması',
      'icon': Icons.brightness_auto,
    },
    {
      'mode': ThemeMode.light,
      'name': 'Açık Tema',
      'icon': Icons.brightness_high,
    },
    {
      'mode': ThemeMode.dark,
      'name': 'Koyu Tema',
      'icon': Icons.brightness_2,
    },
  ];
  /*void _showLimitedOfferDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                
                // Crown icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                const Text(
                  'Premium Üye Ol',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Price
                const Text(
                  '29.99 TL/Ay',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Features
                _buildFeatureRow('Sınırsız film ve dizi keyfi'),
                _buildFeatureRow('Reklamsız izleme deneyimi'),
                _buildFeatureRow('Tüm cihazlarda sınırsız izleme'),
                _buildFeatureRow('Yüksek çözünürlük (4K) desteği'),
                
                const SizedBox(height: 24),
                
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Add subscription logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE21221),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Hemen Üye Ol',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Terms text
                const Text(
                  'Üyeliğiniz her ay otomatik olarak yenilenecektir. İstediğiniz zaman iptal edebilirsiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/
  
 /* Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }*/
  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    final token = authBloc.currentUser?.token ?? '';
    context.read<FilmBloc>().add(FetchFavoriteFilms(token));
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  
                   const Text(
                      'Profil Detayı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LimitedOfferScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Sınırlı Teklif',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Profile Info
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[700]!, width: 2),
                    ),
                    child: ClipOval(
                      child: user?.photoUrl != null
                          ? Image.network(
                              user!.photoUrl!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${user?.id ?? '-'}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final authBloc = context.read<AuthBloc>();
                      if (authBloc.state is AuthSuccess) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => UploadPhotoSheet(
                            onPhotoUploaded: (photoUrl) {
                              final currentUser = (authBloc.state as AuthSuccess).user;
                              final updatedUser = currentUser.copyWith(photoUrl: photoUrl);
                              authBloc.add(AuthUserUpdated(updatedUser));
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Fotoğraf Ekle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Theme Selection
              _buildThemeSelection(),
              const SizedBox(height: 16),
              
              // Liked Movies Section
              const Text(
                'Beğendiğim Filmler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              // Movies Grid
              Expanded(
                child: BlocBuilder<FilmBloc, FilmState>(
                  builder: (context, state) {
                    if (state is FilmLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      );
                    } else if (state is FavoriteFilmsLoaded) {
                      if (state.films.isEmpty) {
                        return _buildSampleMoviesGrid();
                      }
                      return _buildMoviesGrid(state.films);
                    } else if (state is FilmError) {
                      return _buildSampleMoviesGrid();
                    }
                    return _buildSampleMoviesGrid();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
     // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMoviesGrid(List<FilmModel> films) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: films.length,
      itemBuilder: (context, index) {
        final film = films[index];
        return _buildMovieCard(film);
      },
    );
  }

  Widget _buildThemeSelection() {
    final currentTheme = context.read<SettingsCubit>().state.themeMode;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'Tema',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _themes.map((theme) {
              final isSelected = currentTheme == theme['mode'];
              return GestureDetector(
                onTap: () => context.read<SettingsCubit>().changeTheme(theme['mode']),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        theme['icon'],
                        color: isSelected ? Colors.red : Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theme['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  }

  Widget _buildSampleMoviesGrid() {
    // Sample movies to show when no favorites are available
    final sampleMovies = [
      {
        'title': 'Aşk, Ekmek, Hayaller',
        'subtitle': 'Adam Yapım',
        'image': 'https://via.placeholder.com/200x300/333/fff?text=Film1',
      },
      {
        'title': 'Gece Karanlık',
        'subtitle': 'Fox Studios',
        'image': 'https://via.placeholder.com/200x300/333/fff?text=Film2',
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: sampleMovies.length,
      itemBuilder: (context, index) {
        final movie = sampleMovies[index];
        return _buildSampleMovieCard(
          movie['title']!,
          movie['subtitle']!,
          movie['image']!,
        );
      },
    );
  }

  Widget _buildMovieCard(FilmModel film) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              film.posterUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          film.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (film.description.isNotEmpty)
          Text(
            film.description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildSampleMovieCard(String title, String subtitle, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  

