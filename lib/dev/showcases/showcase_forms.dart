import 'package:flutter/material.dart';
import '../component_showcase.dart';
import '../../core/widgets/forms/my_text_field.dart';
import '../../core/widgets/forms/my_password_field.dart';
import '../../core/widgets/forms/my_text_area.dart';
import '../../core/widgets/forms/my_dropdown_field.dart';
import '../../core/widgets/forms/my_checkbox.dart';
import '../../core/widgets/forms/my_radio_group.dart';
import '../../core/widgets/forms/my_switch_field.dart';
import '../../core/widgets/forms/my_slider_field.dart';
import '../../core/widgets/forms/my_date_field.dart';
import '../../core/widgets/forms/my_chip_selector.dart';
import '../../core/widgets/forms/my_rating_bar.dart';
import '../../core/widgets/forms/my_form_section.dart';
import '../../core/widgets/forms/my_stepper_field.dart';
import '../../core/widgets/forms/my_searchable_dropdown.dart';
import '../../core/widgets/forms/my_tag_input.dart';
import '../../core/widgets/forms/my_pin_field.dart';
import '../../core/widgets/forms/my_form_card.dart';
import '../../core/widgets/forms/my_toggle_group.dart';
import '../../core/widgets/forms/my_color_picker.dart';
import '../../core/widgets/forms/my_file_upload_field.dart';

class ShowcaseForms extends StatefulWidget {
  const ShowcaseForms({super.key});

  @override
  State<ShowcaseForms> createState() => _ShowcaseFormsState();
}

class _ShowcaseFormsState extends State<ShowcaseForms> {
  // Estados para enlazar con los campos interactivos
  String _dropdownValue = 'Opción A';
  bool _checkboxValue = false;
  String _radioValue = 'Opción 1';
  bool _switchValue = true;
  double _sliderValue = 0.5;
  DateTime? _selectedDate = DateTime.now();
  List<String> _selectedChips = ['Música'];
  int _ratingValue = 4;
  int _stepperValue = 3;
  String _searchableValue = 'Madrid';
  List<String> _tags = ['Flutter', 'Awesome'];
  String _pinValue = '';
  String _toggleValue = 'Día';
  Color _selectedColor = const Color(0xFF3B82F6);
  String? _uploadedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text(
            '4. Formularios',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        MyFormCard(
          child: MyFormSection(
            title: 'Ejemplo de Formulario Premium',
            subtitle: 'Todos los campos de entrada integrados en el sistema.',
            children: [
              const ComponentShowcase(
                title: 'MyTextField',
                description: 'Campo de texto con validación y decoración premium.',
                child: MyTextField(
                  label: 'Nombre completo',
                  hintText: 'Ingresa tu nombre',
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              const ComponentShowcase(
                title: 'MyPasswordField',
                description: 'Campo de contraseña con botón de visibilidad.',
                child: MyPasswordField(
                  label: 'Contraseña de seguridad',
                ),
              ),
              const ComponentShowcase(
                title: 'MyTextArea',
                description: 'Campo de texto de múltiples líneas con contador.',
                child: MyTextArea(
                  label: 'Comentarios adicionales',
                  hintText: 'Escribe tu mensaje aquí...',
                  maxLines: 3,
                  maxLength: 150,
                ),
              ),
              ComponentShowcase(
                title: 'MyDropdownField',
                description: 'Selector desplegable clásico estilizado.',
                child: MyDropdownField<String>(
                  label: 'Categoría preferida',
                  value: _dropdownValue,
                  prefixIcon: Icons.category_outlined,
                  items: const [
                    DropdownMenuItem(value: 'Opción A', child: Text('Opción A')),
                    DropdownMenuItem(value: 'Opción B', child: Text('Opción B')),
                    DropdownMenuItem(value: 'Opción C', child: Text('Opción C')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _dropdownValue = val);
                  },
                ),
              ),
              ComponentShowcase(
                title: 'MyCheckbox',
                description: 'Casilla de verificación animada.',
                child: MyCheckbox(
                  label: 'Acepto los términos de servicio',
                  subtitle: 'Al marcar esto confirmas los acuerdos.',
                  value: _checkboxValue,
                  onChanged: (val) {
                    if (val != null) setState(() => _checkboxValue = val);
                  },
                ),
              ),
              ComponentShowcase(
                title: 'MyRadioGroup',
                description: 'Opciones exclusivas de selección.',
                child: MyRadioGroup<String>(
                  title: 'Elige una opción obligatoria',
                  options: const ['Opción 1', 'Opción 2', 'Opción 3'],
                  selectedValue: _radioValue,
                  isHorizontal: true,
                  onChanged: (val) => setState(() => _radioValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MySwitchField',
                description: 'Toggle de activación/desactivación.',
                child: MySwitchField(
                  label: 'Notificaciones vía SMS',
                  subtitle: 'Enviar alertas telefónicas importantes.',
                  value: _switchValue,
                  onChanged: (val) => setState(() => _switchValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MySliderField',
                description: 'Control deslizante numérico.',
                child: MySliderField(
                  label: 'Porcentaje de volumen',
                  value: _sliderValue,
                  min: 0.0,
                  max: 1.0,
                  valueSuffix: '%',
                  onChanged: (val) => setState(() => _sliderValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyDateField',
                description: 'Selector de fecha con calendario nativo.',
                child: MyDateField(
                  label: 'Fecha de nacimiento',
                  selectedDate: _selectedDate,
                  onDateSelected: (val) => setState(() => _selectedDate = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyChipSelector',
                description: 'Selector múltiple dinámico basado en chips.',
                child: MyChipSelector<String>(
                  label: 'Elige tus pasatiempos',
                  options: const ['Música', 'Cine', 'Deportes', 'Libros'],
                  selectedOptions: _selectedChips,
                  onChanged: (val) => setState(() => _selectedChips = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyRatingBar',
                description: 'Calificación interactiva por estrellas.',
                child: MyRatingBar(
                  rating: _ratingValue,
                  onChanged: (val) => setState(() => _ratingValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyStepperField',
                description: 'Incrementador/decrementador numérico.',
                child: MyStepperField(
                  label: 'Número de acompañantes',
                  value: _stepperValue,
                  onChanged: (val) => setState(() => _stepperValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MySearchableDropdown',
                description: 'Dropdown con motor de búsqueda en BottomSheet.',
                child: MySearchableDropdown<String>(
                  label: 'Ciudad de residencia',
                  options: const ['Madrid', 'Barcelona', 'Sevilla', 'Valencia', 'Zaragoza'],
                  selectedValue: _searchableValue,
                  onChanged: (val) => setState(() => _searchableValue = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyTagInput',
                description: 'Generador de etiquetas por texto.',
                child: MyTagInput(
                  label: 'Añadir etiquetas de búsqueda',
                  tags: _tags,
                  onTagsChanged: (val) => setState(() => _tags = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyPinField',
                description: 'Celdas para entrada de código PIN.',
                child: Column(
                  children: [
                    MyPinField(
                      length: 4,
                      onChanged: (val) => setState(() => _pinValue = val),
                    ),
                    const SizedBox(height: 8),
                    Text('Código ingresado: $_pinValue', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ComponentShowcase(
                title: 'MyToggleGroup',
                description: 'Control de botones agrupados premium.',
                child: Row(
                  children: [
                    Expanded(
                      child: MyToggleGroup<String>(
                        options: const ['Día', 'Semana', 'Mes'],
                        selectedOption: _toggleValue,
                        onChanged: (val) => setState(() => _toggleValue = val),
                      ),
                    ),
                  ],
                ),
              ),
              ComponentShowcase(
                title: 'MyColorPicker',
                description: 'Selector de color de paleta.',
                child: MyColorPicker(
                  label: 'Elige un color de marca',
                  selectedColor: _selectedColor,
                  onColorSelected: (val) => setState(() => _selectedColor = val),
                ),
              ),
              ComponentShowcase(
                title: 'MyFileUploadField',
                description: 'Simulador de carga de archivos.',
                child: Column(
                  children: [
                    MyFileUploadField(
                      label: 'Cargar hoja de vida (CV)',
                      onFileSelected: (val) => setState(() => _uploadedFileName = val),
                    ),
                    if (_uploadedFileName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Archivo subido: $_uploadedFileName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
