# Flujo de Trabajo con Git y Pull Requests (PRs)

Para mantener un historial limpio, trazable y un código libre de errores, todo el equipo y los agentes automatizados deben adherirse a las siguientes convenciones de control de versiones.

---

## 1. Estrategia de Ramas (Branching Strategy)
Utilizamos un flujo simplificado basado en el desarrollo de características (Feature Branch Workflow). La rama `main` siempre debe ser desplegable a producción.

**Prefijos obligatorios para crear ramas:**
- `feature/nombre-de-la-funcionalidad` (Para nuevas características o componentes de UI).
- `bugfix/nombre-del-error` (Para correcciones de errores no críticos).
- `hotfix/nombre-del-error-critico` (Para parches urgentes en producción).
- `docs/nombre-del-documento` (Para actualizaciones exclusivas de documentación).
- `test/nombre-de-la-prueba` (Para agregar cobertura o robots).

> ❌ **Prohibido:** Hacer commits directamente a la rama `main`.

---

## 2. Convención de Commits (Conventional Commits)
Los mensajes de los commits deben ser semánticos, claros y estar en **inglés** o **español** (pero consistentes). La estructura es: `<tipo>: <descripción corta>`.

**Tipos permitidos:**
- `feat:` Una nueva característica (ej. `feat: add MyButton atomic component`).
- `fix:` Una corrección de error (ej. `fix: prevent text overflow in CustomDrawer`).
- `docs:` Cambios solo en la documentación (ej. `docs: update CI/CD checklist`).
- `style:` Cambios que no afectan la lógica (espacios, formateo con `dart format`).
- `refactor:` Un cambio de código que ni corrige un error ni añade una característica.
- `test:` Añadir pruebas faltantes o corregir existentes.
- `chore:` Tareas de mantenimiento, actualización de dependencias (`pubspec.yaml`), etc.

---

## 3. Reglas para crear un Pull Request (PR)
Antes de solicitar que tu código sea fusionado (merged) en `main`, debes asegurar que cumpla con nuestro pipeline de calidad.

### Definition of Done (DoD) local
Antes de hacer el push final y abrir el PR, ejecuta en tu terminal:
```bash
./dev.sh all
```
*Este script garantiza que tu código está formateado, no tiene warnings, pasa todos los tests y cumple con la cobertura.*

### Lista de Verificación del PR
- [ ] El título del PR sigue la convención de commits (ej. `feat: Implement ResponsiveLayoutBuilder`).
- [ ] Se adjuntan capturas de pantalla o GIFs en la descripción del PR si el cambio afecta la UI (obligatorio).
- [ ] Los Checklists de QA modulares (`documentation/testing/checklists/`) afectados han sido actualizados/marcados.
- [ ] Se requiere la aprobación de al menos 1 revisor (humano o agente de revisión) antes de hacer Merge.