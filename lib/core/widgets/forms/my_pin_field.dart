import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de PIN/Código OTP con múltiples celdas individuales y transiciones de foco.
///
/// ```dart
/// MyPinField(
///   length: 4,
///   onChanged: (code) { ... },
/// )
/// ```
class MyPinField extends StatefulWidget {
  const MyPinField({
    super.key,
    required this.length,
    required this.onChanged,
  });

  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<MyPinField> createState() => _MyPinFieldState();
}

class _MyPinFieldState extends State<MyPinField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    
    // Recopilar pin completo
    final pin = _controllers.map((c) => c.text).join();
    widget.onChanged(pin);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.length, (index) {
          return SizedBox(
            width: 50,
            height: 56,
            child: KeyboardListener(
              focusNode: FocusNode(), // Nodo de teclado local
              onKeyEvent: (event) {
                if (event is KeyDownEvent && 
                    event.logicalKey == LogicalKeyboardKey.backspace && 
                    _controllers[index].text.isEmpty && 
                    index > 0) {
                  _controllers[index - 1].clear();
                  _focusNodes[index - 1].requestFocus();
                }
              },
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cs.onSurface),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: cs.surface,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                ),
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          );
        }),
      ),
    );
  }
}
