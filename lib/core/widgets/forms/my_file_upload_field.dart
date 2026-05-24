import 'package:flutter/material.dart';

/// Un campo de carga de archivos (File Upload) simulado con estados e indicador de progreso.
///
/// ```dart
/// MyFileUploadField(
///   label: 'Comprobante de Pago',
///   onFileSelected: (fileName) { ... },
/// )
/// ```
class MyFileUploadField extends StatefulWidget {
  const MyFileUploadField({
    super.key,
    required this.label,
    required this.onFileSelected,
    this.allowedExtensions = const ['pdf', 'png', 'jpg'],
  });

  final String label;
  final ValueChanged<String?> onFileSelected;
  final List<String> allowedExtensions;

  @override
  State<MyFileUploadField> createState() => _MyFileUploadFieldState();
}

class _MyFileUploadFieldState extends State<MyFileUploadField> {
  String? _fileName;
  bool _isUploading = false;
  double _progress = 0.0;

  void _simulateUpload() {
    setState(() {
      _isUploading = true;
      _progress = 0.0;
      _fileName = null;
    });

    // Simular progreso de carga de archivo
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return false;
      setState(() {
        _progress += 0.2;
      });
      if (_progress >= 1.0) {
        setState(() {
          _isUploading = false;
          _fileName = 'documento_soporte.${widget.allowedExtensions.first}';
        });
        widget.onFileSelected(_fileName);
        return false;
      }
      return true;
    });
  }

  void _removeFile() {
    setState(() {
      _fileName = null;
      _progress = 0.0;
      _isUploading = false;
    });
    widget.onFileSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: (_isUploading || _fileName != null) ? null : _simulateUpload,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isUploading
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.12),
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: _isUploading
                  ? Column(
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: cs.primary, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          'Subiendo archivo...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: cs.primary.withValues(alpha: 0.15),
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    )
                  : _fileName != null
                      ? Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, color: cs.primary, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _fileName!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: cs.error),
                              onPressed: _removeFile,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: cs.onSurface.withValues(alpha: 0.4),
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Haz clic para cargar un archivo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Extensiones permitidas: ${widget.allowedExtensions.join(", ").toUpperCase()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
