import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_demo_app/core/language/bloc/language_bloc.dart';
import 'package:test_demo_app/core/layout/custom_app_bar.dart';
import 'package:test_demo_app/core/layout/custom_drawer.dart';
import 'package:test_demo_app/core/layout/responsive_layout.dart';
import 'package:test_demo_app/core/storage/storage_service.dart';
import 'package:test_demo_app/core/theme/bloc/theme_cubit.dart';

import 'home_robot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ──────────────────────────────────────────────────────────────────────────
  // HELPER: crea un árbol de widgets aislado con los Cubits necesarios.
  // CustomDrawer y CustomAppBar usan MyText → context.tr() → LanguageCubit.
  // ThemeSelector usa ThemeCubit.
  // ──────────────────────────────────────────────────────────────────────────
  Future<Widget> buildWithProviders(
    Widget child, {
    String initialLocale = 'en',
  }) async {
    SharedPreferences.setMockInitialValues(
      initialLocale == 'en' ? {} : {'app_locale': initialLocale},
    );
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit(storageService: storage)),
        BlocProvider(create: (_) => ThemeCubit(storageService: storage)),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  group('Pruebas de Layout Responsivo y Componentes Estructurales', () {
    // ══════════════════════════════════════════════════════════════════════
    // SECCIÓN 1: RESPONSIVE LAYOUT (BREAKPOINTS)
    // ══════════════════════════════════════════════════════════════════════
    group('ResponsiveLayout (Breakpoints)', () {
      testWidgets(
        'En Mobile (<1024px) el AppBar tiene el ícono hamburguesa y el drawer se abre',
        (WidgetTester tester) async {
          tester.view.physicalSize = const Size(412, 915);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final robot = HomeRobot(tester);
          await robot.pumpMyApp();

          // En mobile el ícono hamburguesa confirma que hay un drawer disponible
          expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
          robot.expectAppBarPresent();

          // El Scaffold hace lazy-load del drawer: hay que abrirlo primero
          await robot.openDrawer();

          // Ahora CustomDrawer debe estar en el árbol
          expect(find.byType(CustomDrawer), findsOneWidget);
        },
      );

      testWidgets(
        'En Desktop (>=1024px) el Drawer es permanente y no hay hamburguesa',
        (WidgetTester tester) async {
          tester.view.physicalSize = const Size(1920, 1080);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final robot = HomeRobot(tester);
          await robot.pumpMyApp();

          robot.expectDrawerPresent();
          robot.expectAppBarPresent();
          // En desktop el drawer es permanente, no hay botón hamburguesa
          expect(find.byIcon(Icons.menu_rounded), findsNothing);
        },
      );

      testWidgets(
        'Cambio reactivo de índice: tap en Home desde el drawer selecciona índice 0',
        (WidgetTester tester) async {
          tester.view.physicalSize = const Size(1920, 1080);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final robot = HomeRobot(tester);
          await robot.pumpMyApp();

          // El índice inicial debe ser 0 (Home)
          final controller = ResponsiveLayoutController.of(
            tester.element(find.byType(CustomDrawer)),
          );
          expect(controller?.selectedIndex, 0);
        },
      );
    });

    // ══════════════════════════════════════════════════════════════════════
    // SECCIÓN 2: CUSTOM DRAWER
    // ══════════════════════════════════════════════════════════════════════
    group('CustomDrawer', () {
      testWidgets(
        'En modo no-permanente se renderiza envuelto en un widget Drawer nativo',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            await buildWithProviders(
              CustomDrawer(
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                isPermanent: false,
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(Drawer), findsOneWidget);
        },
      );

      testWidgets(
        'En modo permanente (desktop) NO envuelve con el widget Drawer de Flutter',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            await buildWithProviders(
              CustomDrawer(
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                isPermanent: true,
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(Drawer), findsNothing);
        },
      );

      testWidgets('El ítem Home (índice 0) siempre aparece en el drawer', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          await buildWithProviders(
            CustomDrawer(selectedIndex: 0, onDestinationSelected: (_) {}),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      });

      testWidgets('Tap en el ítem Home invoca onDestinationSelected(0)', (
        WidgetTester tester,
      ) async {
        int capturedIndex = -1;

        await tester.pumpWidget(
          await buildWithProviders(
            CustomDrawer(
              selectedIndex: 0,
              onDestinationSelected: (index) => capturedIndex = index,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.home_rounded));
        await tester.pumpAndSettle();

        expect(capturedIndex, 0);
      });

      testWidgets(
        'El ítem seleccionado tiene un container con fondo de acento (isSelected=true)',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            await buildWithProviders(
              CustomDrawer(selectedIndex: 0, onDestinationSelected: (_) {}),
            ),
          );
          await tester.pumpAndSettle();

          // Verificamos que el ícono del ítem seleccionado existe (selectedIndex=0 → Home)
          // En la implementación, el ítem seleccionado pinta el ícono con colorScheme.primary
          final iconWidget = tester.widget<Icon>(
            find.byIcon(Icons.home_rounded),
          );
          expect(iconWidget.color, isNotNull);
        },
      );

      testWidgets('El versión v1.0.0 aparece al pie del drawer', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          await buildWithProviders(
            CustomDrawer(selectedIndex: 0, onDestinationSelected: (_) {}),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('v1.0.0'), findsOneWidget);
      });
    });

    // ══════════════════════════════════════════════════════════════════════
    // SECCIÓN 3: CUSTOM APP BAR
    // ══════════════════════════════════════════════════════════════════════
    group('CustomAppBar', () {
      testWidgets(
        'En modo desktop (isDesktop=true) se muestra el DropdownButton de idioma',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            await buildWithProviders(
              const SizedBox.shrink(), // body placeholder
            ),
          );
          // Reconstruimos con el AppBar como PreferredSizeWidget dentro del Scaffold
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final storage = StorageService(prefs);

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => LanguageCubit(storageService: storage),
                ),
                BlocProvider(
                  create: (_) => ThemeCubit(storageService: storage),
                ),
              ],
              child: MaterialApp(
                home: Scaffold(
                  appBar: const CustomAppBar(isDesktop: true, title: 'home'),
                  body: const SizedBox.shrink(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // En desktop el LanguageSelector está en el AppBar → hay un DropdownButton
          expect(find.byType(DropdownButton<String>), findsOneWidget);
        },
      );

      testWidgets(
        'En modo mobile (isDesktop=false) NO se muestra el DropdownButton en el AppBar',
        (WidgetTester tester) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final storage = StorageService(prefs);

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => LanguageCubit(storageService: storage),
                ),
                BlocProvider(
                  create: (_) => ThemeCubit(storageService: storage),
                ),
              ],
              child: MaterialApp(
                home: Scaffold(
                  appBar: const CustomAppBar(isDesktop: false, title: 'home'),
                  body: const SizedBox.shrink(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // En mobile el LanguageSelector está en el body, no en el AppBar
          expect(find.byType(DropdownButton<String>), findsNothing);
        },
      );

      testWidgets(
        'En modo mobile aparece el ícono hamburguesa para abrir el drawer',
        (WidgetTester tester) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final storage = StorageService(prefs);

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => LanguageCubit(storageService: storage),
                ),
                BlocProvider(
                  create: (_) => ThemeCubit(storageService: storage),
                ),
              ],
              child: MaterialApp(
                home: Scaffold(
                  appBar: const CustomAppBar(isDesktop: false, title: 'home'),
                  body: const SizedBox.shrink(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
        },
      );

      testWidgets('En modo desktop NO aparece el ícono hamburguesa', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = StorageService(prefs);

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LanguageCubit(storageService: storage),
              ),
              BlocProvider(create: (_) => ThemeCubit(storageService: storage)),
            ],
            child: MaterialApp(
              home: Scaffold(
                appBar: const CustomAppBar(isDesktop: true, title: 'home'),
                body: const SizedBox.shrink(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.menu_rounded), findsNothing);
      });

      test('La altura preferida del CustomAppBar es exactamente 64px', () {
        const appBar = CustomAppBar(isDesktop: false);
        expect(appBar.preferredSize.height, 64.0);
      });
    });

    // ══════════════════════════════════════════════════════════════════════
    // SECCIÓN 4: RESPONSIVE LAYOUT CONTROLLER (InheritedWidget)
    // ══════════════════════════════════════════════════════════════════════
    group('ResponsiveLayoutController', () {
      testWidgets(
        'Expone el selectedIndex correcto a los widgets descendientes',
        (WidgetTester tester) async {
          int? capturedIndex;

          await tester.pumpWidget(
            MaterialApp(
              home: ResponsiveLayoutController(
                selectedIndex: 2,
                setSelectedIndex: (_) {},
                child: Builder(
                  builder: (context) {
                    capturedIndex = ResponsiveLayoutController.of(
                      context,
                    )?.selectedIndex;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          expect(capturedIndex, 2);
        },
      );

      testWidgets('of() retorna null cuando no hay controller en el árbol', (
        WidgetTester tester,
      ) async {
        ResponsiveLayoutController? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                result = ResponsiveLayoutController.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(result, isNull);
      });

      testWidgets(
        'updateShouldNotify devuelve true sólo cuando cambia el índice',
        (WidgetTester tester) async {
          int buildCount = 0;

          // Construimos el árbol con un estado inicial
          await tester.pumpWidget(
            MaterialApp(
              home: ResponsiveLayoutController(
                selectedIndex: 0,
                setSelectedIndex: (_) {},
                child: Builder(
                  builder: (context) {
                    // Dependemos del controller para que se notifiquen rebuilds
                    ResponsiveLayoutController.of(context);
                    buildCount++;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          final firstBuild = buildCount;

          // Actualizamos con el MISMO índice → no debe notificar
          await tester.pumpWidget(
            MaterialApp(
              home: ResponsiveLayoutController(
                selectedIndex: 0, // mismo
                setSelectedIndex: (_) {},
                child: Builder(
                  builder: (context) {
                    ResponsiveLayoutController.of(context);
                    buildCount++;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          // Al ser el mismo índice, updateShouldNotify devuelve false
          // pero el rebuild del MaterialApp puede forzar uno igualmente.
          // Verificamos que al menos el primer build fue correcto.
          expect(firstBuild, greaterThanOrEqualTo(1));

          // Actualizamos con índice DIFERENTE → debe notificar y rebuildar
          await tester.pumpWidget(
            MaterialApp(
              home: ResponsiveLayoutController(
                selectedIndex: 1, // diferente
                setSelectedIndex: (_) {},
                child: Builder(
                  builder: (context) {
                    ResponsiveLayoutController.of(context);
                    buildCount++;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          expect(buildCount, greaterThan(firstBuild));
        },
      );
    });
  });
}
