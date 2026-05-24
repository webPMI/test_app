import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_demo_app/core/theme/bloc/theme_cubit.dart';
import 'package:test_demo_app/core/theme/bloc/theme_state.dart';
import 'package:test_demo_app/core/storage/storage_service.dart';
import 'package:test_demo_app/core/widgets/theme_selector.dart';
import 'home_robot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas Completas de Tema (Theme Tests)', () {
    
    // ==========================================
    // SECCIÓN 1: PRUEBAS UNITARIAS DE LÓGICA
    // ==========================================
    group('ThemeCubit (Lógica)', () {
      late ThemeCubit themeCubit;
      late StorageService storageService;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        storageService = StorageService(prefs);
        themeCubit = ThemeCubit(storageService: storageService);
      });

      tearDown(() {
        themeCubit.close();
      });

      test('El estado inicial debe ser ThemeMode.system e IndigoSlate si no hay guardado previo', () {
        expect(
          themeCubit.state,
          const ThemeState(themeMode: ThemeMode.system, palette: ThemePalette.indigoSlate),
        );
      });

      test('Debe cargar el tema y la paleta guardados desde el StorageService al inicializar', () async {
        SharedPreferences.setMockInitialValues({
          'app_theme_mode': 'dark',
          'app_theme_palette': 'emeraldAmber',
        });
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs);
        final newCubit = ThemeCubit(storageService: storage);

        expect(
          newCubit.state,
          const ThemeState(themeMode: ThemeMode.dark, palette: ThemePalette.emeraldAmber),
        );
        await newCubit.close();
      });

      test('Debe persistir y emitir un nuevo estado cuando llamamos a setTheme(dark)', () async {
        expectLater(
          themeCubit.stream,
          emitsInOrder([
            const ThemeState(themeMode: ThemeMode.dark, palette: ThemePalette.indigoSlate),
          ]),
        );

        await themeCubit.setTheme(ThemeMode.dark);

        expect(storageService.getString('app_theme_mode'), 'dark');
        expect(themeCubit.state.themeMode, ThemeMode.dark);
      });

      test('Debe persistir y emitir un nuevo estado cuando llamamos a setPalette(cyberpunkRose)', () async {
        expectLater(
          themeCubit.stream,
          emitsInOrder([
            const ThemeState(themeMode: ThemeMode.system, palette: ThemePalette.cyberpunkRose),
          ]),
        );

        await themeCubit.setPalette(ThemePalette.cyberpunkRose);

        expect(storageService.getString('app_theme_palette'), 'cyberpunkRose');
        expect(themeCubit.state.palette, ThemePalette.cyberpunkRose);
      });

      test('Debe alternar entre Claro y Oscuro con toggleTheme()', () async {
        await themeCubit.setTheme(ThemeMode.dark);
        expect(themeCubit.state.themeMode, ThemeMode.dark);

        await themeCubit.toggleTheme();
        expect(themeCubit.state.themeMode, ThemeMode.light);
        expect(storageService.getString('app_theme_mode'), 'light');

        await themeCubit.toggleTheme();
        expect(themeCubit.state.themeMode, ThemeMode.dark);
        expect(storageService.getString('app_theme_mode'), 'dark');
      });
    });

    // ==========================================
    // SECCIÓN 2: PRUEBAS DE INTERFAZ Y COMPORTAMIENTO
    // ==========================================
    group('Theme (Interfaz de Usuario)', () {
      testWidgets('El botón de cambiar tema alterna los iconos de modo oscuro/claro reactivamente', (
        WidgetTester tester,
      ) async {
        final robot = HomeRobot(tester);

        // Cargar la app
        await robot.pumpMyApp();

        // Por defecto no está en modo oscuro, así que debería mostrar el icono para pasar a oscuro
        robot.expectThemeIcon(Icons.dark_mode);

        // Tocar el botón de cambiar tema
        await robot.tapThemeButton();

        // Ahora debería estar en modo oscuro y mostrar el icono para pasar a claro
        robot.expectThemeIcon(Icons.light_mode);

        // Tocar el botón de cambiar tema otra vez
        await robot.tapThemeButton();

        // Vuelve al icono de modo oscuro
        robot.expectThemeIcon(Icons.dark_mode);
      });

      testWidgets('Tocar los círculos de color cambia la paleta de tema y actualiza el check visualmente', (
        WidgetTester tester,
      ) async {
        final robot = HomeRobot(tester);

        // Cargar la app
        await robot.pumpMyApp();

        // Por defecto la paleta inicial debe ser Indigo Slate y tener el check
        robot.expectPaletteSelected('Indigo Slate');

        // Cambiar a la paleta Cyberpunk Rose
        await robot.selectThemePalette('Cyberpunk Rose');

        // El check debe moverse a la paleta Cyberpunk Rose
        robot.expectPaletteSelected('Cyberpunk Rose');

        // Cambiar a la paleta Emerald Amber
        await robot.selectThemePalette('Emerald Amber');

        // El check debe moverse a la paleta Emerald Amber
        robot.expectPaletteSelected('Emerald Amber');

        // Cambiar a la nueva paleta Royal Gold
        await robot.selectThemePalette('Royal Gold');

        // El check debe moverse a la paleta Royal Gold
        robot.expectPaletteSelected('Royal Gold');
      });

      testWidgets('El selector de tipo Dropdown se renderiza y cambia la paleta', (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs);
        final themeCubit = ThemeCubit(storageService: storage);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<ThemeCubit>.value(value: themeCubit),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: ThemeSelector(type: ThemeSelectorType.dropdown),
              ),
            ),
          ),
        );

        // Debería renderizar un DropdownButton con el valor seleccionado
        expect(find.byType(DropdownButton<ThemePalette>), findsOneWidget);
        
        // Abrir el dropdown
        await tester.tap(find.byType(DropdownButton<ThemePalette>));
        await tester.pumpAndSettle();

        // Tocar el item de Emerald Amber en el dropdown
        await tester.tap(find.text('Emerald Amber').last);
        await tester.pumpAndSettle();

        expect(themeCubit.state.palette, ThemePalette.emeraldAmber);
        themeCubit.close();
      });

      testWidgets('El selector de tipo Grid se renderiza y cambia la paleta', (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs);
        final themeCubit = ThemeCubit(storageService: storage);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<ThemeCubit>.value(value: themeCubit),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: ThemeSelector(type: ThemeSelectorType.grid),
              ),
            ),
          ),
        );

        // Debería renderizar las tarjetas del grid, por ejemplo, "Sunset Glow"
        expect(find.text('Sunset Glow'), findsOneWidget);
        
        // Tocar la tarjeta Sunset Glow
        await tester.tap(find.text('Sunset Glow'));
        await tester.pumpAndSettle();

        expect(themeCubit.state.palette, ThemePalette.sunsetOrange);
        themeCubit.close();
      });
    });
  });
}
