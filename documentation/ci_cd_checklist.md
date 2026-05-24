# Checklist de Integración Continua y Calidad (CI/CD)

Asegura que la calidad del código se valide automáticamente en cada commit y que el pipeline de CI/CD esté configurado correctamente.

---

## Pipeline de Calidad Local (`./dev.sh`)

### Comandos disponibles
- [x] `./dev.sh analyze` → Análisis estático con `flutter analyze` (0 warnings, 0 errors).
- [x] `./dev.sh test` → Ejecuta todas las pruebas unitarias y de widgets con cobertura.
- [x] `./dev.sh e2e` → Ejecuta las pruebas de integración E2E autodetectando el dispositivo.
- [x] `./dev.sh all` → Pipeline completo: `analyze` → `test` → `e2e`.

### Estado actual del pipeline

| Comando | Estado | Resultado |
|---|---|---|
| `flutter analyze` | ✅ OK | 0 errores, 0 warnings |
| `flutter test` | ✅ OK | Todos los tests pasan |
| `dart format` | ✅ OK | Código formateado |
| `flutter test --coverage` | ✅ Disponible | Genera `coverage/lcov.info` |

---

## Cobertura de Código

### Cómo generar el reporte
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html   # Requiere lcov instalado
```

### Objetivos de cobertura
- [ ] Cobertura total ≥ 80% de líneas.
- [ ] Cobertura de `StorageService` ≥ 95%.
- [ ] Cobertura de `LanguageCubit` ≥ 90%.
- [ ] Cobertura de `ThemeCubit` ≥ 90%.
- [ ] Cobertura de `Tr` ≥ 95%.
- [ ] Cobertura de widgets de UI ≥ 70%.

---

## Análisis Estático y Formato

- [x] `flutter analyze` sin errores ni warnings en el código de producción.
- [x] `dart format --output=none --set-exit-if-changed .` pasa sin cambios pendientes.
- [x] `analysis_options.yaml` configurado con reglas de `flutter_lints`.
- [ ] Reglas adicionales activadas: `avoid_dynamic_calls`, `prefer_final_locals`, `avoid_print`.

---

## Automatización CI (Pendiente de configurar)

### GitHub Actions (propuesta)
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter test --coverage
```

### Lista de checks para el CI remoto
- [ ] Flutter SDK instalado y cacheado en el runner de CI.
- [ ] `flutter pub get` se ejecuta antes de cualquier análisis o test.
- [ ] `flutter analyze` falla el build si hay errores.
- [ ] `flutter test --coverage` falla el build si algún test falla.
- [ ] El reporte de cobertura se sube a una plataforma (ej. Codecov, Coveralls).
- [ ] Las pruebas E2E se ejecutan en un runner con emulador Android/iOS o Chrome.
- [ ] Los artefactos de build (`.apk`, `.ipa`) se generan y archivan en cada release.

---

## Reglas del Proceso de PR

- [ ] Ningún PR puede mergearse con tests fallando.
- [ ] Ningún PR puede mergearse con warnings de `flutter analyze`.
- [ ] La cobertura no debe bajar más de un 2% respecto a la rama principal.
- [ ] Los tests nuevos deben cubrir cualquier lógica nueva añadida al Cubit.
