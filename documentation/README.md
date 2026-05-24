# Herramientas de Desarrollo (DevTools)

Este dominio documenta los recursos creados para agilizar el flujo de trabajo del equipo.

## 1. Automatización: `dev.sh`
En la raíz del proyecto existe un script de Bash para automatizar las prácticas de calidad.
*   `./dev.sh analyze`: Ejecuta el Linter (`flutter analyze`).
*   `./dev.sh test`: Corre las pruebas unitarias y genera cobertura.
*   `./dev.sh e2e`: Lanza las pruebas de integración en el dispositivo conectado.
*   `./dev.sh all`: Corre el pipeline completo antes de hacer un commit/Push.

## 2. El "DevCenter" (Consola en la App)
Para facilitar la depuración, la aplicación cuenta con un entorno oculto (`DevScreen` y `DevInfoPanel`) accesible desde el menú lateral (`CustomDrawer`).

*   **Seguridad**: El acceso al DevCenter está protegido mediante la constante `kDebugMode`. Nunca aparecerá en los builds de producción (Release).
*   **Características**: Permite visualizar en tiempo real el idioma de la app, el modo de brillo actual y la paleta de colores inyectada por el `ThemeCubit`.

## 3. Flujo de Trabajo (Git & PRs)
Para mantener un historial limpio y un código libre de errores, el equipo sigue reglas estrictas de control de versiones. 

*   Consulta la **Guía de Flujo de Trabajo con Git y Pull Requests** para conocer las convenciones de ramas, creación de commits y los requisitos ("Definition of Done") para aprobar un PR.

## 4. Arquitectura del Planeador

La documentación del planeamiento fue separada en dos guías independientes:

*   Base de datos: `documentation/architecture_planning/database_architecture_guide.md`
*   Frontend y widgets: `documentation/architecture_planning/frontend_widgets_guide.md`

*(Próximamente: Documentación sobre logs, inspección de red y flags visuales)*