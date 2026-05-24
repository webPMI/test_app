# 50 Widgets Reutilizables con Prefijo `My` — Plan e Inventario del Sistema de Diseño

Este documento sirve como inventario oficial y hoja de ruta para los componentes del Sistema de Diseño (Design System) de la aplicación. Todos los componentes se estructuran según la metodología de Diseño Atómico (Atomic Design).

---

## Estructura de Componentes en el Sistema (50)

```text
lib/core/widgets/
├── my_text.dart                    ← Base Text widget
├── language_selector.dart          ← Idioma selector
├── theme_selector.dart             ← Tema selector
│
├── atoms/
│   ├── my_badge.dart              # 01 - Badge/Etiqueta básica
│   ├── my_button.dart             # 02 - Botón estándar
│   ├── my_icon_button.dart        # 03 - Botón con icono
│   ├── my_avatar.dart             # 04 - Avatar con iniciales
│   ├── my_divider.dart            # 05 - Separador horizontal
│   ├── my_spinner.dart            # 06 - Spinner de carga animado
│   └── my_network_image.dart      # 07 - Imagen de red con shimmer
│
├── molecules/
│   ├── my_card.dart               # 08 - Tarjeta estructural
│   ├── my_list_tile.dart          # 09 - Ítem de lista estándar
│   ├── my_info_chip.dart          # 10 - Chip eliminable
│   ├── my_stat_card.dart          # 11 - Tarjeta de estadísticas
│   ├── my_search_bar.dart         # 12 - Barra de búsqueda
│   ├── my_progress_bar.dart       # 13 - Barra de progreso
│   ├── my_alert_banner.dart       # 14 - Banner de alerta
│   ├── my_menu_item.dart          # 15 - Opción de menú
│   ├── my_tooltip_wrapper.dart    # 16 - Tooltip premium
│   ├── my_notification_badge.dart # 17 - Superposición de badge
│   ├── my_breadcrumbs.dart        # 18 - Rastro de navegación
│   ├── my_accordion.dart          # 19 - Acordeón colapsable
│   └── my_toast.dart              # 20 - Alerta flotante premium
│
├── organisms/
│   ├── my_section_header.dart     # 21 - Encabezado de sección
│   ├── my_empty_state.dart        # 22 - Estado vacío con ilustración
│   ├── my_tab_bar.dart            # 23 - Pestañas de navegación
│   ├── my_tag_list.dart           # 24 - Lista horizontal de tags
│   ├── my_timeline_item.dart      # 25 - Hito cronológico
│   ├── my_expandable_card.dart    # 26 - Tarjeta colapsable detallada
│   ├── my_stepper_steps.dart      # 27 - Pasos jerárquicos horizontales
│   ├── my_bottom_bar.dart         # 28 - Barra de navegación flotante
│   ├── my_carousel.dart           # 29 - Carrusel de elementos
│   └── my_dialog.dart             # 30 - Cuadro de diálogo modal
│
├── forms/
│   ├── my_text_field.dart         # 31 - Campo de texto estándar
│   ├── my_password_field.dart     # 32 - Campo de contraseña
│   ├── my_text_area.dart          # 33 - Entrada de texto multilínea
│   ├── my_dropdown_field.dart     # 34 - Selector desplegable
│   ├── my_checkbox.dart           # 35 - Casilla de verificación
│   ├── my_radio_group.dart        # 36 - Grupo de radio botones
│   ├── my_switch_field.dart       # 37 - Interruptor de switch
│   ├── my_slider_field.dart       # 38 - Deslizador numérico
│   ├── my_date_field.dart         # 39 - Campo con date picker
│   ├── my_chip_selector.dart      # 40 - Selector múltiple por chips
│   ├── my_rating_bar.dart         # 41 - Calificación por estrellas
│   ├── my_form_section.dart       # 42 - Divisor de formularios
│   ├── my_stepper_field.dart      # 43 - Control numérico incrementable
│   ├── my_searchable_dropdown.dart # 44 - Dropdown con buscador
│   ├── my_tag_input.dart          # 45 - Input generador de etiquetas
│   ├── my_pin_field.dart          # 46 - Entrada para PIN/OTP
│   ├── my_form_card.dart          # 47 - Tarjeta contenedora de formulario
│   ├── my_toggle_group.dart       # 48 - Segmented control
│   ├── my_color_picker.dart       # 49 - Grid selector de colores
│   └── my_file_upload_field.dart  # 50 - Carga simulada de archivos
│
└── my_widgets.dart                ← Barrel export centralizado de los 50 componentes
```

---

## Verificación de Calidad e Integración (Definition of Done)

Para asegurar la estabilidad del sistema, todos los componentes han cumplido los siguientes requisitos:

- [x] **Completitud**: Los 50 componentes están implementados y exportados por `my_widgets.dart`.
- [x] **Linter**: El comando `flutter analyze` pasa sin advertencias ni errores estáticos.
- [x] **Pruebas**: Cada componente cuenta con sus respectivas pruebas unitarias y de renderizado en `my_widgets_test.dart`.
- [x] **Consola de Desarrollo**: Todos los widgets están inyectados en sus respectivos paneles de Showcase para pruebas manuales interactivas en temas claros/oscuros.
- [x] **Sin Overflows**: Los componentes manejan etiquetas largas de forma flexible (ej. usando `Expanded` y `Flexible` en las Rows) para ajustarse a dispositivos móviles compactos.
