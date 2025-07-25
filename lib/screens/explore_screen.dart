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
    return Scaffold(
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
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
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed:
              null, // Favori işlemi için API güncellemesi gerekirse burada yapılacak.
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
