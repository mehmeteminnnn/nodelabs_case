import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/film_bloc.dart';
import '../bloc/settings_cubit.dart';
import '../models/film_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FilmBloc>().add(FetchFavoriteFilms());
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/explore');
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık Alanı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const Text(
                    'Profil Detayı',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Sınırlı Teklif',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tema ve Dil Seçici
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tema seçici
                  Row(
                    children: [
                      const Icon(Icons.brightness_6, color: Colors.white),
                      const SizedBox(width: 8),
                      DropdownButton<ThemeMode>(
                        value: context.watch<SettingsCubit>().state.themeMode,
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Koyu'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Açık'),
                          ),
                        ],
                        onChanged: (mode) {
                          if (mode != null) {
                            context.read<SettingsCubit>().changeTheme(mode);
                          }
                        },
                      ),
                    ],
                  ),
                  // Dil seçici
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.white),
                      const SizedBox(width: 8),
                      DropdownButton<Locale>(
                        value: context.watch<SettingsCubit>().state.locale,
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(
                            value: Locale('tr'),
                            child: Text('Türkçe'),
                          ),
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            context.read<SettingsCubit>().changeLocale(locale);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Profil Bilgisi
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        user?.profilePhoto != null &&
                                user!.profilePhoto!.isNotEmpty
                            ? NetworkImage(user.profilePhoto!)
                            : const AssetImage('assets/images/profile.jpg')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user != null ? 'ID: ${user.id}' : '',
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Profil fotoğrafı yükleme ekranına yönlendirme
                      Navigator.pushNamed(context, '/upload_profile_photo');
                    },
                    child: const Text('Fotoğraf Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Beğendiğim Filmler
              const Text(
                'Beğendiğim Filmler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Film Grid
              Expanded(
                child: BlocBuilder<FilmBloc, FilmState>(
                  builder: (context, state) {
                    if (state is FilmLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavoriteFilmsLoaded) {
                      if (state.films.isEmpty) {
                        return const Center(
                          child: Text(
                            'Favori filminiz yok.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                        children:
                            state.films
                                .map((film) => _buildMovieCard(film))
                                .toList(),
                      );
                    } else if (state is FilmError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(FilmModel film) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            film.imageUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          film.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(film.description, style: const TextStyle(color: Colors.white60)),
      ],
    );
  }
}
