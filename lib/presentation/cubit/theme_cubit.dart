import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

// Theme State
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  ThemeCubit(this._prefs)
    : super(ThemeState(isDarkMode: _prefs.getBool(_themeKey) ?? false));

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await _prefs.setBool(_themeKey, newValue);
    emit(ThemeState(isDarkMode: newValue));
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
    emit(ThemeState(isDarkMode: isDark));
  }
}
