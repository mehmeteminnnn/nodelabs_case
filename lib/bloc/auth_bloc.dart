import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/api_service.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';
import 'package:equatable/equatable.dart';

// Olaylar
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
  @override
  List<Object?> get props => [name, email, password];
}

// Stateler
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await apiService.post('/user/login', {
        'email': event.email,
        'password': event.password,
      });
      if (response.statusCode == 200) {
        final data = AuthResponse.fromJson(jsonDecode(response.body));
        emit(AuthSuccess(data.user));
      } else if (response.statusCode == 400) {
        emit(AuthFailure('Kullanıcı bilgileri yanlış. Lütfen tekrar deneyin.'));
      } else {
        emit(AuthFailure('Giriş başarısız. Lütfen tekrar deneyin.'));
      }
    } catch (e) {
      emit(AuthFailure('Bir hata oluştu: $e'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await apiService.post('/user/register', {
        'name': event.name,
        'email': event.email,
        'password': event.password,
      });
      if (response.statusCode == 200) {
        final data = AuthResponse.fromJson(jsonDecode(response.body));
        emit(AuthSuccess(data.user));
      } else if (response.statusCode == 400) {
        print('Register 400 response: ' + response.body);
        emit(AuthFailure('Kullanıcı bilgileri yanlış. Lütfen tekrar deneyin.'));
      } else {
        print(
          'Register error: statusCode= [33m [1m [4m${response.statusCode} [0m, body=${response.body}',
        );
        emit(AuthFailure('Kayıt başarısız. Lütfen tekrar deneyin.'));
      }
    } catch (e) {
      emit(AuthFailure('Bir hata oluştu: $e'));
    }
  }

  UserModel? get currentUser {
    if (state is AuthSuccess) {
      return (state as AuthSuccess).user;
    }
    return null;
  }
}
