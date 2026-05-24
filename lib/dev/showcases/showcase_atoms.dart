import 'package:flutter/material.dart';
import '../component_showcase.dart';
import '../../core/widgets/my_text.dart';
import '../../core/widgets/atoms/my_button.dart';
import '../../core/widgets/atoms/my_badge.dart';
import '../../core/widgets/atoms/my_avatar.dart';
import '../../core/widgets/atoms/my_divider.dart';
import '../../core/widgets/atoms/my_spinner.dart';
import '../../core/widgets/atoms/my_network_image.dart';

class ShowcaseAtoms extends StatelessWidget {
  const ShowcaseAtoms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            '1. Átomos',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const ComponentShowcase(
          title: 'MyText',
          description:
              'Componente base para textos responsivos y traducibles automáticamente.',
          child: MyText(
            'app_name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ComponentShowcase(
          title: 'MyButton',
          description:
              'Botones con estados (loading, disabled) y variantes semánticas.',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MyButton(label: 'Primary', onPressed: () {}),
              MyButton(
                label: 'Destructive',
                variant: MyButtonVariant.destructive,
                icon: Icons.delete_outline,
                onPressed: () {},
              ),
              MyButton(label: 'Loading', isLoading: true, onPressed: () {}),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyBadge',
          description:
              'Etiquetas visuales pequeñas para indicar estados o categorías.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MyBadge(label: 'Success', variant: MyBadgeVariant.success),
              MyBadge(label: 'Warning', variant: MyBadgeVariant.warning),
              MyBadge(
                label: 'Error',
                variant: MyBadgeVariant.error,
                icon: Icons.error_outline,
              ),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyAvatar',
          description:
              'Representación visual de usuarios (extrae iniciales dinámicamente).',
          child: Row(
            children: [
              MyAvatar(name: 'Developer Mode'),
              SizedBox(width: 12),
              MyAvatar(name: 'Admin User'),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyDivider',
          description:
              'Separadores horizontales con la opción de incluir etiquetas de texto.',
          child: Column(
            children: [
              MyDivider(),
              SizedBox(height: 12),
              MyDivider(label: 'O continuar con'),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MySpinner',
          description:
              'Indicador de carga animado premium (tipo circular y dots secuenciales).',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MySpinner(type: MySpinnerType.circular),
              MySpinner(type: MySpinnerType.dots, size: 30),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyNetworkImage',
          description:
              'Imágenes de red con shimmer animado al cargar y placeholder de error.',
          child: Row(
            children: [
              Expanded(
                child: MyNetworkImage(
                  imageUrl: 'https://picsum.photos/300/200',
                  height: 120,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: MyNetworkImage(
                  imageUrl: 'https://invalid-url-for-error.com/img.png',
                  height: 120,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
