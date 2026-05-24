import 'package:flutter/material.dart';

/// Un contenedor premium de imágenes de red con shimmer de carga y manejo de errores.
///
/// ```dart
/// MyNetworkImage(
///   imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5',
///   height: 200,
///   width: double.infinity,
///   borderRadius: BorderRadius.circular(16),
/// )
/// ```
class MyNetworkImage extends StatefulWidget {
  const MyNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.shadows,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final List<BoxShadow>? shadows;

  @override
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: widget.shadows,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Image.network(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child: child,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            // Renderiza el shimmer premium
            return AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, _) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.onSurface.withValues(alpha: 0.05),
                        cs.onSurface.withValues(alpha: 0.12),
                        cs.onSurface.withValues(alpha: 0.05),
                      ],
                      stops: const [0.1, 0.5, 0.9],
                      begin: Alignment(-2.0 + _shimmerController.value * 4.0, -1.0),
                      end: Alignment(-1.0 + _shimmerController.value * 4.0, 1.0),
                    ),
                  ),
                );
              },
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: widget.width,
              height: widget.height,
              color: cs.errorContainer.withValues(alpha: 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_rounded,
                    color: cs.error,
                    size: widget.height != null ? (widget.height! * 0.25).clamp(24.0, 48.0) : 32.0,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No se pudo cargar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onErrorContainer,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
