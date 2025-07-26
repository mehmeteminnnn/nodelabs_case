import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/film_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../models/film_model.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    final token = authBloc.currentUser?.token ?? '';
    context.read<FilmBloc>().add(FetchFilms(1, token: token));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<FilmBloc>().state;
      if (state is FilmLoaded && !state.hasReachedMax) {
        final authBloc = context.read<AuthBloc>();
        final token = authBloc.currentUser?.token ?? '';
        context.read<FilmBloc>().add(FetchFilms((state.films.length ~/ 5) + 1, token: token));
      }
    }
  }

  Future<void> _onRefresh() async {
    final authBloc = context.read<AuthBloc>();
    final token = authBloc.currentUser?.token ?? '';
    context.read<FilmBloc>().add(FetchFilms(1, token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black87,
      body: SafeArea(
        child: BlocBuilder<FilmBloc, FilmState>(
          builder: (context, state) {
            if (state is FilmLoading && (state is! FilmLoaded)) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FilmLoaded) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      state.hasReachedMax
                          ? state.films.length
                          : state.films.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.films.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final film = state.films[index];
                    return _buildFilmCard(film, context);
                  },
                ),
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
      /*bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                // Already on explore screen, do nothing
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Anasayfa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),*/
    );
  }

  Widget _buildFilmCard(FilmModel film, BuildContext context) {
    return Card(
      color: Colors.black87,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(
          film.posterUrl,
          width: 60,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 90,
            color: Colors.grey[800],
            child: const Icon(Icons.movie, color: Colors.white54, size: 30),
          ),
        ),
        title: Text(
          film.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          film.description,
          style: const TextStyle(color: Colors.white70),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            film.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: film.isFavorite ? Colors.red : Colors.white,
            size: 28,
          ),
          onPressed: () {
            // Toggle favorite status
            setState(() {
              film.isFavorite = !film.isFavorite;
            });
            
            // Here you can add API call to update favorite status on the server
            // For example:
            // final authBloc = context.read<AuthBloc>();
            // final token = authBloc.currentUser?.token ?? '';
            // context.read<FilmBloc>().add(ToggleFavorite(film.id, token));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
