import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/language/bloc/language_bloc.dart';
import 'core/language/bloc/language_state.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/bloc/theme_cubit.dart';
import 'core/theme/bloc/theme_state.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.storageService});

  final StorageService storageService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageCubit(storageService: storageService)),
        BlocProvider(create: (context) => ThemeCubit(storageService: storageService)),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeState.themeMode,
                theme: AppTheme.getLightTheme(themeState.palette),
                darkTheme: AppTheme.getDarkTheme(themeState.palette),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('es')],
                home: const HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
