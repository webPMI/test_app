# Guía y Estrategia de Testing en test_demo_app

Esta documentación define la estrategia de pruebas, la estructura del proyecto y los checklists necesarios para mantener la aplicación robusta y de calidad profesional.

---

## 1. Estructura de Pruebas del Proyecto

Hemos organizado las pruebas siguiendo los principios de la arquitectura limpia, separando las responsabilidades lógicas, de interfaz y de integración:

```
test_demo_app/
├── integration_test/
│   └── app_test.dart              # Flujos completos de extremo a extremo (E2E)
└── test/
    ├── home_robot.dart            # Robot de interacción (Robot Pattern)
    ├── language_bloc_test.dart    # Pruebas unitarias de idioma (Cubit y Traductor)
    ├── layout_test.dart           # Pruebas de layout responsivo y componentes estructurales
    ├── storage_service_test.dart  # Pruebas unitarias del StorageService
    ├── theme_test.dart            # Pruebas unitarias y de widget del Tema
    ├── widget_test.dart           # Pruebas de interfaz y responsividad
    ├── widgets/                   # Pruebas de widgets organizadas por categorías
    │   ├── atoms_test.dart        # Pruebas de Atoms (7 widgets)
    │   ├── molecules_test.dart    # Pruebas de Molecules (13 widgets)
    │   ├── organisms_test.dart    # Pruebas de Organisms (10 widgets)
    │   └── forms_test.dart        # Pruebas de Forms (20 widgets)
    └── responsive_test_utils.dart # Utilidades para layouts multidispositivo
```

### Detalle de las Pruebas

1. **Pruebas Unitarias del Idioma (`language_bloc_test.dart`)**:
    * Verifica que el [LanguageCubit](file:///c:/Users/inken/development/test_demo_app/lib/core/language/bloc/language_bloc.dart) detecte el idioma del sistema cuando no hay datos guardados.
    * Verifica la correcta carga y escritura en el almacenamiento local genérico [StorageService](file:///c:/Users/inken/development/test_demo_app/lib/core/storage/storage_service.dart).
    * Comprueba que la lógica de traducción e interpolación de la clase [Tr](file:///c:/Users/inken/development/test_demo_app/lib/core/language/language_translation.dart) funcione.
    * **Nuevos casos negativos**: locale no soportado (`'zz'`), locale inválido guardado en storage, `Tr.of()` estático, parámetros vacíos/nulos.

2. **Pruebas del StorageService (`storage_service_test.dart`)**:
    * Lectura de los 4 tipos (`String`, `bool`, `int`, `double`) para claves existentes y no existentes.
    * Escritura y lectura posterior de todos los tipos, incluyendo sobreescritura de valores.
    * Verifica que todos los setters devuelven `true` al guardar correctamente.
    * Verifica que `remove()` elimina la clave y no afecta a las demás claves almacenadas.

3. **Pruebas Completas del Tema (`theme_test.dart`)**:
    * **Pruebas Unitarias**: Valida que [ThemeCubit](file:///c:/Users/inken/development/test_demo_app/lib/core/theme/bloc/theme_cubit.dart) inicialice, persista y actualice el modo de brillo y la paleta seleccionada.
    * **Pruebas de Widgets**: Simula interacciones táctiles en el [ThemeSelector](file:///c:/Users/inken/development/test_demo_app/lib/core/widgets/theme_selector.dart) y verifica que el tema cambie.

5. **Pruebas de Layout Responsivo y Componentes (`layout_test.dart`)**:
    * **Breakpoints**: Verifica el comportamiento en mobile (<1024px) y desktop (>=1024px), incluyendo la presencia del ícono hamburguesa y el modo permanente del drawer.
    * **CustomDrawer**: Tests aislados con providers correctos — modo permanente vs `Drawer` nativo, tap en ítems, índice seleccionado, versión en el pie.
    * **CustomAppBar**: Verifica la presencia del `DropdownButton` en desktop y su ausencia en mobile, el ícono hamburguesa, y la altura preferida de 64px.
    * **ResponsiveLayoutController**: Tests del `InheritedWidget` — exposición del índice, retorno `null` fuera del árbol, y `updateShouldNotify`.
    > **Nota técnica**: El `Scaffold` de Flutter hace lazy-load del contenido del `Drawer`. `CustomDrawer` sólo aparece en el árbol de widgets después de abrir el drawer programáticamente.

6. **Pruebas de Extremo a Extremo E2E (`integration_test/app_test.dart`)**:
    * Valida flujos multi-paso en dispositivos o emuladores reales sin simular bindings nativos.

---

## 2. Cobertura Actual de Tests

| Archivo de Test | Tests | Estado |
|---|---|---|
| `language_bloc_test.dart` | 16 | ✅ Todos pasan |
| `storage_service_test.dart` | 18 | ✅ Todos pasan |
| `theme_test.dart` | 7 | ✅ Todos pasan |
| `layout_test.dart` | 17 | ✅ Todos pasan |
| `widget_test.dart` | 5 (4 responsive + 1 reactividad) | ✅ Todos pasan |
| `widgets/atoms_test.dart` | 8 | ✅ Todos pasan |
| `widgets/molecules_test.dart` | 13 | ✅ Todos pasan |
| `widgets/organisms_test.dart` | 10 | ✅ Todos pasan |
| `widgets/forms_test.dart` | 20 | ✅ Todos pasan |
| `home_robot.dart` | *(helper compartido)* | — |
| **Total** | **116** | **✅ 116/116** |

> **Bug corregido durante la revisión**: El `Row` del header de [CustomDrawer](file:///c:/Users/inken/development/test_demo_app/lib/core/layout/custom_drawer.dart) desbordaba 56px en resolución Desktop (1920×1080). Corregido envolviendo el texto `app_name` con `Expanded` y añadiendo `TextOverflow.ellipsis`.

---

## 3. Automatización y Comandos de Ejecución

Para simplificar la ejecución y asegurar la calidad de la aplicación en cada commit, disponemos del script de automatización unificado `./dev.sh` (con lógica fraccionada en el directorio `./scripts/`):

* **Ayuda e información general**:
    ```bash
    ./dev.sh help
    ```
* **Análisis estático y formato**:
    ```bash
    ./dev.sh analyze
    ```
* **Pruebas unitarias/widgets y cobertura automática**:
    ```bash
    ./dev.sh test
    ```
* **Pruebas de extremo a extremo E2E (autodetectando dispositivo)**:
    ```bash
    ./dev.sh e2e
    ```
    *(Opcional: Forzar dispositivo específico)*:
    ```bash
    ./dev.sh e2e chrome
    ./dev.sh e2e windows
    ./dev.sh e2e emulator-5554
    ```
* **Pipeline completo de calidad (analizar -> test -> e2e)**:
    ```bash
    ./dev.sh all
    ```

---

### Comandos Nativos de Flutter (Uso manual)
Si prefieres ejecutar el flujo de manera manual o no dispones de un shell compatible con Bash:

* **Pruebas Unitarias y de Widgets**: `flutter test`
* **Análisis Estático**: `flutter analyze`
* **Verificar Formato de Código**: `dart format --output=none --set-exit-if-changed .`
* **Cobertura de Código**: `flutter test --coverage`
* **Generar Reporte HTML de Cobertura** *(requiere `lcov`)*:
    ```bash
    genhtml coverage/lcov.info -o coverage/html
    ```

---

## 4. Arquitectura y Patrones Profesionales en E2E

### Reutilización del Robot Pattern
Para mantener un desarrollo limpio y evitar duplicación de código, compartimos la clase [HomeRobot](file:///c:/Users/inken/development/test_demo_app/test/home_robot.dart) tanto en pruebas de widgets locales como en pruebas de integración E2E. El Robot encapsula las consultas (`Finder`) e interacciones (`tester.tap`, `selectLanguage`, etc.), de modo que los archivos de prueba se concentran únicamente en definir las aserciones y flujos lógicos.

### Ciclo de Vida y Persistencia Real
A diferencia de las pruebas de widgets clásicas donde mockeamos el almacenamiento con `SharedPreferences.setMockInitialValues`, las pruebas en `integration_test/` corren sobre la plataforma real de destino.
* **Flujo de Reinicio (Restart Simulation)**: Evaluamos la persistencia de configuraciones re-ejecutando `app.main()` dentro de la misma prueba. Esto fuerza a que se inicie un nuevo árbol de widgets y se lean los datos reales persistidos por el driver nativo de base de datos (`SharedPreferences`) del sistema operativo, validando que el estado persista tal como lo experimentará el usuario final.

---

## 5. Estrategias de Mitigación de Errores y Calidad (Producción)
Para que el testing sea robusto y evitar vulnerabilidades, es obligatorio aplicar estas prácticas a medida que la aplicación escala:
- **Mocking Riguroso**: Utilizar paquetes como `mocktail` o `mockito` para aislar componentes lógicos (Cubit/Bloc) de dependencias externas (APIs, bases de datos). Nunca se debe depender de servicios reales en las pruebas unitarias.
- **Pruebas de Casos Negativos (Negative Testing)**: Es crucial probar cómo reacciona el código ante excepciones, timeouts o datos nulos/corruptos para asegurar una degradación elegante.
- **Golden Tests**: Incorporar el paquete `golden_toolkit` u oficial para tomar "capturas" en la ejecución y asegurar que los cambios de código no alteren inadvertidamente el diseño visual.

---

## 6. Checklists Modulares de Testing
Para mantener el proyecto organizado a medida que crece, hemos dividido las responsabilidades de pruebas en diferentes listas de control. Consulta cada archivo para ver qué falta por cubrir y marcar tu progreso:

- [x] **[Checklist de Interfaz (UI) y Accesibilidad](testing/checklists/ui_widget_checklist.md)**: Estilos, Accesibilidad, Interacción y Golden Tests.
- [ ] **[Checklist de Layout Responsivo y Componentes](testing/checklists/responsive_components_checklist.md)**: Breakpoints, Componentes Atómicos y Eficiencia de Renderizado.
- [x] **[Checklist de Lógica y Estado](testing/checklists/logic_state_checklist.md)**: Cubits, Blocs y Casos Negativos.
- [ ] **[Checklist de Navegación y Rutas](testing/checklists/navigation_routing_checklist.md)**: Navegación adaptativa, Guards y Deep Linking.
- [x] **[Checklist de Infraestructura](testing/checklists/infrastructure_checklist.md)**: Servicios (Storage), API, Traductor.
- [x] **[Checklist de Extremo a Extremo (E2E)](testing/checklists/e2e_integration_checklist.md)**: Flujos reales, red y persistencia.
- [x] **[Checklist de Integración Continua (CI/CD)](testing/checklists/ci_cd_checklist.md)**: Cobertura, Linter y automatización.

---

## 7. Requisitos y Aserciones Obligatorias de las Pruebas

Toda nueva prueba añadida a la aplicación debe satisfacer obligatoriamente los siguientes estándares y aserciones para garantizar la estabilidad del software:

### A. Para Widgets e Interfaz (UI)
*   **Aserción de Renderizado**: Verificar que los textos de etiquetas, placeholders e iconos principales se dibujan correctamente (`find.text` o `find.byIcon`).
*   **Interacción y Estado**: Confirmar que al hacer tap en elementos interactivos (botones, checkboxes, switches, estrellas de calificación, segmented controls) se dispara la callback correspondiente (`onPressed` / `onChanged`) y se propaga el nuevo valor en el árbol.
*   **Aislamiento de Entorno**: Envolver siempre los widgets probados en contenedores con los Providers necesarios (ej. `MaterialApp`, `Scaffold`, `MultiBlocProvider`) para evitar excepciones de contexto.
*   **Casos de Carga y Bloqueo**: Para botones o formularios con estado de carga (`isLoading`), verificar que el spinner se dibuje y que la acción de tap quede bloqueada (no debe ejecutar la callback de acción).
*   **Formatos e Iniciales**: Para avatares u otros formateadores dinámicos, realizar pruebas con entradas nulas, vacías y con múltiples nombres para asegurar que no se produzcan desbordamientos ni excepciones de rango de texto.

### B. Para Lógica y Estado (Cubit/Bloc)
*   **Persistencia**: Verificar que los Cubits/Blocs leen los datos preexistentes del almacenamiento e inician con el estado esperado.
*   **Validación de Eventos**: Confirmar que cada acción emitida por el usuario genera la secuencia correcta de estados (e.g. `LanguageCubit` transiciona a español/inglés al llamar a `changeLanguage`).
*   **Manejo de Errores**: Todo test de servicio debe incluir aserciones para casos límites (claves inexistentes en el almacenamiento, locales no soportados o datos nulos), confirmando que el sistema devuelve valores por defecto de forma segura en lugar de fallar catastróficamente.

