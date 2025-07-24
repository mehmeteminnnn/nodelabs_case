import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  SettingsState({required this.locale, required this.themeMode});

  SettingsState copyWith({Locale? locale, ThemeMode? themeMode}) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(locale: const Locale('tr'), themeMode: ThemeMode.dark),
      );

  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void changeTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
