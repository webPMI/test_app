import 'package:flutter/material.dart';
import 'my_text_field.dart';

/// Campo de contraseña premium con botón de revelado integrado.
///
/// ```dart
/// MyPasswordField(
///   label: 'Contraseña',
///   controller: _passController,
/// )
/// ```
class MyPasswordField extends StatefulWidget {
  const MyPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<MyPasswordField> createState() => _MyPasswordFieldState();
}

class _MyPasswordFieldState extends State<MyPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MyTextField(
      label: widget.label,
      controller: widget.controller,
      obscureText: _obscureText,
      prefixIcon: Icons.lock_outlined,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: cs.onSurface.withValues(alpha: 0.5),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
