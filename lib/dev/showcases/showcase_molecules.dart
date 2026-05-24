import 'package:flutter/material.dart';
import '../component_showcase.dart';
import '../../core/widgets/molecules/my_alert_banner.dart';
import '../../core/widgets/molecules/my_list_tile.dart';
import '../../core/widgets/molecules/my_card.dart';
import '../../core/widgets/molecules/my_progress_bar.dart';
import '../../core/widgets/molecules/my_menu_item.dart';
import '../../core/widgets/molecules/my_info_chip.dart';
import '../../core/widgets/molecules/my_stat_card.dart';
import '../../core/widgets/molecules/my_search_bar.dart';
import '../../core/widgets/molecules/my_tooltip_wrapper.dart';
import '../../core/widgets/molecules/my_notification_badge.dart';
import '../../core/widgets/molecules/my_breadcrumbs.dart';
import '../../core/widgets/molecules/my_accordion.dart';
import '../../core/widgets/molecules/my_toast.dart';
import '../../core/widgets/atoms/my_button.dart';

class ShowcaseMolecules extends StatelessWidget {
  const ShowcaseMolecules({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text(
            '2. Moléculas',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const ComponentShowcase(
          title: 'MyAlertBanner',
          description:
              'Mensajes contextuales llamativos para mostrar alertas en pantalla.',
          child: MyAlertBanner(
            message: 'El sistema ha detectado una actualización disponible.',
            type: MyAlertType.info,
          ),
        ),
        ComponentShowcase(
          title: 'MyListTile',
          description:
              'Elemento de lista interactivo para menús y configuraciones.',
          child: MyListTile(
            title: 'Ajustes de desarrollador',
            subtitle: 'Gestiona configuraciones experimentales.',
            onTap: () {},
          ),
        ),
        ComponentShowcase(
          title: 'MyCard',
          description:
              'Contenedor estructural con título y un área de acciones inferior opcional.',
          child: MyCard(
            title: 'Detalles de la Cuenta',
            subtitle: 'Información básica de facturación.',
            actions: [
              MyButton(
                label: 'Cancelar',
                variant: MyButtonVariant.ghost,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              MyButton(label: 'Actualizar', onPressed: () {}),
            ],
            child: const Text(
              'Aquí puede ir cualquier componente hijo complejo de la UI.',
            ),
          ),
        ),
        const ComponentShowcase(
          title: 'MyProgressBar',
          description: 'Barra de progreso animada con porcentaje opcional.',
          child: Column(
            children: [
              MyProgressBar(
                value: 0.72,
                label: 'Descarga en curso',
                showPercent: true,
              ),
              SizedBox(height: 16),
              MyProgressBar(
                value: null,
                label: 'Modo Indeterminado (Cargando...)',
              ),
            ],
          ),
        ),
        ComponentShowcase(
          title: 'MyMenuItem',
          description: 'Ítem de menú contextual para listas o popups.',
          child: Column(
            children: [
              MyMenuItem(
                icon: Icons.edit,
                label: 'Editar perfil',
                onTap: () {},
              ),
              MyMenuItem(
                icon: Icons.delete_outline,
                label: 'Eliminar cuenta',
                isDestructive: true,
                onTap: () {},
              ),
            ],
          ),
        ),
        ComponentShowcase(
          title: 'MyInfoChip',
          description:
              'Etiqueta con icono y botón de eliminar (útil para filtros).',
          child: Wrap(
            spacing: 8,
            children: [
              MyInfoChip(label: 'Activos', onDeleted: () {}),
              MyInfoChip(
                label: 'Administradores',
                icon: Icons.admin_panel_settings,
                onDeleted: () {},
              ),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyStatCard',
          description: 'Tarjeta para mostrar una métrica clave con tendencia.',
          child: Row(
            children: [
              Expanded(
                child: MyStatCard(
                  title: 'Ingresos',
                  value: '\$12,450',
                  icon: Icons.attach_money,
                  trend: '+14.5%',
                ),
              ),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MySearchBar',
          description: 'Input decorado para búsquedas.',
          child: MySearchBar(hintText: 'Buscar componentes...'),
        ),
        const ComponentShowcase(
          title: 'MyTooltipWrapper',
          description: 'Envoltorio que muestra un tooltip de diseño premium.',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTooltipWrapper(
                message: 'Información adicional importante.',
                child: Chip(
                  label: Text('Pasa el cursor / Mantén presionado'),
                  avatar: Icon(Icons.help_outline),
                ),
              ),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyNotificationBadge',
          description: 'Superpone globos de notificación numéricos o simples sobre cualquier widget.',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyNotificationBadge(
                count: 8,
                child: Icon(Icons.notifications_rounded, size: 32),
              ),
              MyNotificationBadge(
                count: 120,
                child: Icon(Icons.mail_rounded, size: 32),
              ),
              MyNotificationBadge(
                child: Icon(Icons.chat_bubble_rounded, size: 32),
              ),
            ],
          ),
        ),
        ComponentShowcase(
          title: 'MyBreadcrumbs',
          description: 'Ruta de navegación jerárquica premium.',
          child: MyBreadcrumbs(
            items: [
              MyBreadcrumbItem(label: 'Home', onTap: () {}),
              MyBreadcrumbItem(label: 'Settings', onTap: () {}),
              const MyBreadcrumbItem(label: 'Security'),
            ],
          ),
        ),
        const ComponentShowcase(
          title: 'MyAccordion',
          description: 'Paneles colapsables individuales con animaciones de altura.',
          child: Column(
            children: [
              MyAccordion(
                title: '¿Cuáles son los métodos de pago aceptados?',
                child: Text(
                  'Aceptamos tarjetas de crédito, débito, transferencias bancarias y billeteras digitales autorizadas.',
                ),
              ),
              MyAccordion(
                title: '¿Cómo puedo cancelar mi suscripción?',
                child: Text(
                  'Puedes cancelar tu plan mensual en cualquier momento ingresando a Configuración > Facturación > Cancelar Plan.',
                ),
              ),
            ],
          ),
        ),
        ComponentShowcase(
          title: 'MyToast',
          description: 'Alertas flotantes premium con barra de progreso temporizada.',
          child: Column(
            children: [
              MyToast(
                message: 'Los cambios se guardaron con éxito.',
                type: MyToastType.success,
                onDismiss: () {},
              ),
              const SizedBox(height: 8),
              MyToast(
                message: 'Error al conectar con la base de datos.',
                type: MyToastType.error,
                actionLabel: 'Reintentar',
                onActionPressed: () {},
                onDismiss: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
