import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/film_service.dart';
import '../models/film_model.dart';
import 'package:equatable/equatable.dart';

// Olaylar
abstract class FilmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFilms extends FilmEvent {
  final int page;
  FetchFilms(this.page);
  @override
  List<Object?> get props => [page];
}

class ToggleFavorite extends FilmEvent {
  final int filmId;
  ToggleFavorite(this.filmId);
  @override
  List<Object?> get props => [filmId];
}

class RefreshFilms extends FilmEvent {}

class FetchFavoriteFilms extends FilmEvent {}

// Stateler
abstract class FilmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilmInitial extends FilmState {}

class FilmLoading extends FilmState {}

class FilmLoaded extends FilmState {
  final List<FilmModel> films;
  final bool hasReachedMax;
  FilmLoaded(this.films, {this.hasReachedMax = false});
  @override
  List<Object?> get props => [films, hasReachedMax];
}

class FilmError extends FilmState {
  final String message;
  FilmError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteFilmsLoaded extends FilmState {
  final List<FilmModel> films;
  FavoriteFilmsLoaded(this.films);
  @override
  List<Object?> get props => [films];
}

// Bloc
class FilmBloc extends Bloc<FilmEvent, FilmState> {
  final FilmService filmService;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  List<FilmModel> _films = [];

  FilmBloc(this.filmService) : super(FilmInitial()) {
    on<FetchFilms>(_onFetchFilms);
    on<ToggleFavorite>(_onToggleFavorite);
    on<RefreshFilms>(_onRefreshFilms);
    on<FetchFavoriteFilms>(_onFetchFavoriteFilms);
  }

  Future<void> _onFetchFilms(FetchFilms event, Emitter<FilmState> emit) async {
    if (_hasReachedMax && event.page != 1) return;
    emit(FilmLoading());
    try {
      final films = await filmService.fetchFilms(event.page);
      if (event.page == 1) {
        _films = films;
      } else {
        _films.addAll(films);
      }
      _currentPage = event.page;
      _hasReachedMax = films.length < 5;
      emit(FilmLoaded(List.from(_films), hasReachedMax: _hasReachedMax));
    } catch (e) {
      emit(FilmError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FilmState> emit,
  ) async {
    try {
      await filmService.toggleFavorite(event.filmId);
      _films =
          _films.map((film) {
            if (film.id == event.filmId) {
              return FilmModel(
                id: film.id,
                title: film.title,
                description: film.description,
                imageUrl: film.imageUrl,
                isFavorite: !film.isFavorite,
              );
            }
            return film;
          }).toList();
      emit(FilmLoaded(List.from(_films), hasReachedMax: _hasReachedMax));
    } catch (e) {
      emit(FilmError(e.toString()));
    }
  }

  Future<void> _onRefreshFilms(
    RefreshFilms event,
    Emitter<FilmState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;
    add(FetchFilms(1));
  }

  Future<void> _onFetchFavoriteFilms(
    FetchFavoriteFilms event,
    Emitter<FilmState> emit,
  ) async {
    emit(FilmLoading());
    try {
      final films = await filmService.fetchFavoriteFilms();
      emit(FavoriteFilmsLoaded(films));
    } catch (e) {
      emit(FilmError(e.toString()));
    }
  }
}
