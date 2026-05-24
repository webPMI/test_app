import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'debug_ai_bridge_card.dart';
import 'models/db_entity_definition.dart';
import 'widgets/database_planning_section.dart';

class DevArchitecturePlannerPage extends StatefulWidget {
  const DevArchitecturePlannerPage({super.key});

  @override
  State<DevArchitecturePlannerPage> createState() =>
      _DevArchitecturePlannerPageState();
}

class _DevArchitecturePlannerPageState
    extends State<DevArchitecturePlannerPage> {
  final TextEditingController _projectNameController = TextEditingController(
    text: 'my_final_app',
  );
  final TextEditingController _appNameController = TextEditingController(
    text: 'Mi App',
  );
  final TextEditingController _appDescriptionController = TextEditingController(
    text:
        'App para gestionar operaciones, usuarios y reportes con flujos claros.',
  );
  final TextEditingController _teamSizeController = TextEditingController(
    text: '4',
  );
  final TextEditingController _entityNameController = TextEditingController();
  final TextEditingController _entityFieldsController = TextEditingController();
  final TextEditingController _entityParentController = TextEditingController();

  final Set<String> _features = <String>{'Auth', 'Dashboard'};
  final List<DbEntityDefinition> _customEntities = <DbEntityDefinition>[];
  AppType _appType = AppType.mobile;
  BackendOption _backend = BackendOption.firebase;
  DatabaseOption _database = DatabaseOption.firestore;
  ArchitectureOption _architecture = ArchitectureOption.cleanArchitecture;
  DeploymentOption _deployment = DeploymentOption.cloudRun;
  DomainTemplate _domainTemplate = DomainTemplate.business;
  bool _needsAnalytics = true;
  bool _needsNotifications = true;
  AgentTaskStatus _agentTaskStatus = AgentTaskStatus.notSent;
  DateTime? _agentSentAt;
  DateTime? _agentCompletedAt;
  String? _lastSentFingerprint;

  @override
  void dispose() {
    _projectNameController.dispose();
    _appNameController.dispose();
    _appDescriptionController.dispose();
    _teamSizeController.dispose();
    _entityNameController.dispose();
    _entityFieldsController.dispose();
    _entityParentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recommendations = _buildRecommendations();
    final blueprintLines = _buildBlueprint();
    final schemaText = _buildDatabaseSchemaText();
    final copilotTask = _buildCopilotTask(schemaText);
    final currentFingerprint = _buildConfigFingerprint(copilotTask);
    final hasUnsentChanges =
        _lastSentFingerprint != null &&
        _lastSentFingerprint != currentFingerprint;

    return Scaffold(
      appBar: AppBar(title: const Text('Dev Blueprint Builder'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroCard(context),
                const SizedBox(height: 16),
                _buildProjectConfigCard(context),
                const SizedBox(height: 16),
                _buildDomainAndDescriptionCard(context),
                const SizedBox(height: 16),
                _buildTechnicalConfigCard(context),
                const SizedBox(height: 16),
                const DebugAiBridgeCard(),
                const SizedBox(height: 16),
                _buildFeatureSelectionCard(context),
                const SizedBox(height: 16),
                DatabasePlanningSection(
                  isFirestore: _database == DatabaseOption.firestore,
                  customEntities: _customEntities,
                  entityNameController: _entityNameController,
                  entityFieldsController: _entityFieldsController,
                  entityParentController: _entityParentController,
                  schemaText: schemaText,
                  onAddEntity: _addCustomEntity,
                  onEditEntity: _editCustomEntity,
                  onDeleteEntity: _removeCustomEntityAt,
                  onReorderEntities: _reorderCustomEntities,
                  onLinkParent: _linkEntityToParent,
                  onUnlinkParent: _unlinkEntityParent,
                  onCopySchema: () =>
                      _copyText(context, schemaText, 'Esquema copiado'),
                  onCopyRules: _database == DatabaseOption.firestore
                      ? () => _copyText(
                          context,
                          _buildFirestoreRulesTemplate(),
                          'Reglas Firestore copiadas',
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                _buildCopilotTaskCard(context, copilotTask, currentFingerprint),
                const SizedBox(height: 16),
                _buildAgentStatusCard(context, hasUnsentChanges),
                const SizedBox(height: 16),
                _buildRecommendationsCard(context, recommendations),
                const SizedBox(height: 16),
                _buildBlueprintCard(context, blueprintLines),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Planificador Profesional de Aplicaciones',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Configura en minutos la estructura final de tu app, su arquitectura y base de datos. El sistema analiza tus decisiones y te propone recomendaciones listas para ejecutar.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectConfigCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1) Proyecto y Equipo',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del proyecto (id tecnico)',
                hintText: 'ej: nexa_commerce',
                prefixIcon: Icon(Icons.workspaces_outline),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _appNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre visible de la app',
                hintText: 'ej: Nexa Commerce',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _teamSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tamaño del equipo',
                hintText: 'ej: 4',
                prefixIcon: Icon(Icons.group_outlined),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            SegmentedButton<AppType>(
              segments: const [
                ButtonSegment<AppType>(
                  value: AppType.mobile,
                  label: Text('Mobile'),
                  icon: Icon(Icons.phone_android_rounded),
                ),
                ButtonSegment<AppType>(
                  value: AppType.web,
                  label: Text('Web'),
                  icon: Icon(Icons.language_rounded),
                ),
                ButtonSegment<AppType>(
                  value: AppType.multiplatform,
                  label: Text('Multi'),
                  icon: Icon(Icons.devices_rounded),
                ),
              ],
              selected: <AppType>{_appType},
              onSelectionChanged: (selection) {
                setState(() {
                  _appType = selection.first;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainAndDescriptionCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2) Dominio y Descripcion',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            SegmentedButton<DomainTemplate>(
              segments: const [
                ButtonSegment<DomainTemplate>(
                  value: DomainTemplate.business,
                  label: Text('Negocio'),
                  icon: Icon(Icons.storefront_outlined),
                ),
                ButtonSegment<DomainTemplate>(
                  value: DomainTemplate.courses,
                  label: Text('Cursos'),
                  icon: Icon(Icons.school_outlined),
                ),
                ButtonSegment<DomainTemplate>(
                  value: DomainTemplate.gym,
                  label: Text('Gym'),
                  icon: Icon(Icons.fitness_center_outlined),
                ),
                ButtonSegment<DomainTemplate>(
                  value: DomainTemplate.custom,
                  label: Text('Custom'),
                  icon: Icon(Icons.tune_outlined),
                ),
              ],
              selected: <DomainTemplate>{_domainTemplate},
              onSelectionChanged: (selection) {
                setState(() {
                  _domainTemplate = selection.first;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _appDescriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Describe tu app',
                hintText:
                    'Problema que resuelve, usuarios principales, flujos clave y reglas de negocio.',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description_outlined),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _applyDomainTemplate();
                    });
                  },
                  icon: const Icon(Icons.auto_fix_high_outlined),
                  label: const Text('Cargar sugerencia del dominio'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _customEntities.clear();
                    });
                  },
                  icon: const Icon(Icons.layers_clear_outlined),
                  label: const Text('Limpiar entidades custom'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalConfigCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3) Stack Tecnico',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<BackendOption>(
              initialValue: _backend,
              decoration: const InputDecoration(
                labelText: 'Backend',
                prefixIcon: Icon(Icons.hub_outlined),
              ),
              items: BackendOption.values
                  .map(
                    (option) => DropdownMenuItem<BackendOption>(
                      value: option,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _backend = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DatabaseOption>(
              initialValue: _database,
              decoration: const InputDecoration(
                labelText: 'Base de datos',
                prefixIcon: Icon(Icons.storage_rounded),
              ),
              items: DatabaseOption.values
                  .map(
                    (option) => DropdownMenuItem<DatabaseOption>(
                      value: option,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _database = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ArchitectureOption>(
              initialValue: _architecture,
              decoration: const InputDecoration(
                labelText: 'Arquitectura',
                prefixIcon: Icon(Icons.account_tree_outlined),
              ),
              items: ArchitectureOption.values
                  .map(
                    (option) => DropdownMenuItem<ArchitectureOption>(
                      value: option,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _architecture = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DeploymentOption>(
              initialValue: _deployment,
              decoration: const InputDecoration(
                labelText: 'Deploy recomendado',
                prefixIcon: Icon(Icons.rocket_launch_outlined),
              ),
              items: DeploymentOption.values
                  .map(
                    (option) => DropdownMenuItem<DeploymentOption>(
                      value: option,
                      child: Text(option.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _deployment = value;
                });
              },
            ),
            const SizedBox(height: 14),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Analytics y monitoreo'),
              subtitle: const Text(
                'Eventos de producto, errores y rendimiento',
              ),
              value: _needsAnalytics,
              onChanged: (value) {
                setState(() {
                  _needsAnalytics = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Push notifications'),
              subtitle: const Text(
                'Campañas, engagement y alertas en tiempo real',
              ),
              value: _needsNotifications,
              onChanged: (value) {
                setState(() {
                  _needsNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSelectionCard(BuildContext context) {
    const featureOptions = <String>[
      'Auth',
      'Dashboard',
      'Payments',
      'Chat',
      'Roles & Admin',
      'Offline Mode',
      'Reports',
      'AI Assistant',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4) Modulos del Producto',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: featureOptions
                  .map(
                    (feature) => FilterChip(
                      label: Text(feature),
                      selected: _features.contains(feature),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _features.add(feature);
                          } else {
                            _features.remove(feature);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(
    BuildContext context,
    List<RecommendationItem> recommendations,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '9) Recomendaciones Inteligentes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...recommendations.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: item.color.withValues(alpha: 0.15),
                  child: Icon(item.icon, color: item.color, size: 18),
                ),
                title: Text(item.title),
                subtitle: Text(item.description),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueprintCard(
    BuildContext context,
    List<String> blueprintLines,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '10) Blueprint Ejecutable',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: blueprintLines
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          line,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Blueprint generado. Siguiente paso: convertirlo en scaffolding automático.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marcar como listo para implementación'),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildBlueprint() {
    final cleanName = _projectNameController.text.trim().isEmpty
        ? 'my_final_app'
        : _projectNameController.text.trim();
    final teamSize = int.tryParse(_teamSizeController.text.trim()) ?? 1;

    return [
      'Proyecto: $cleanName',
      'Nombre app: ${_appNameController.text.trim().isEmpty ? 'Mi App' : _appNameController.text.trim()}',
      'Tipo de App: ${_appType.label}',
      'Dominio: ${_domainTemplate.label}',
      'Arquitectura: ${_architecture.label}',
      'Backend: ${_backend.label}',
      'Base de datos: ${_database.label}',
      'Deploy: ${_deployment.label}',
      'Equipo estimado: $teamSize personas',
      'Módulos: ${_features.isEmpty ? 'Sin módulos definidos' : _features.join(', ')}',
      'Observabilidad: ${_needsAnalytics ? 'Sí' : 'No'}',
      'Push notifications: ${_needsNotifications ? 'Sí' : 'No'}',
      'Entidades custom: ${_customEntities.isEmpty ? 'ninguna' : _customEntities.length}',
      'Descripcion:',
      ' ${_appDescriptionController.text.trim().isEmpty ? 'Sin descripcion' : _appDescriptionController.text.trim()}',
      'Estructura sugerida:',
      ' - lib/core (theme, storage, network, error handling)',
      ' - lib/features/* (data, domain, presentation)',
      ' - backend/services (auth, users, billing, notifications)',
      ' - infra/devops (ci, monitoring, environments)',
      ' - docs/adr (decisiones arquitectónicas)',
    ];
  }

  Widget _buildCopilotTaskCard(
    BuildContext context,
    String taskText,
    String fingerprint,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '7) Tarea para Agente en VS Code',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Copia este bloque y pégalo en Copilot Chat. Con eso el agente puede arrancar la implementación del esquema y la estructura de código.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Revision de configuracion: $fingerprint',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                taskText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () =>
                      _copyText(context, taskText, 'Tarea para agente copiada'),
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: const Text('Copiar tarea para Copilot'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _agentTaskStatus = AgentTaskStatus.sent;
                      _agentSentAt = DateTime.now();
                      _lastSentFingerprint = fingerprint;
                    });
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Marcar como enviado'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentStatusCard(BuildContext context, bool hasUnsentChanges) {
    final statusLabel = switch (_agentTaskStatus) {
      AgentTaskStatus.notSent => 'No enviado',
      AgentTaskStatus.sent => 'En trabajo',
      AgentTaskStatus.completed => 'Completado',
    };

    final statusColor = switch (_agentTaskStatus) {
      AgentTaskStatus.notSent => Colors.grey,
      AgentTaskStatus.sent => Colors.orange,
      AgentTaskStatus.completed => Colors.green,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '8) Estado del Trabajo del Agente',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: statusColor.withValues(alpha: 0.2),
                  child: Icon(Icons.circle, color: statusColor, size: 10),
                ),
                const SizedBox(width: 8),
                Text('Estado: $statusLabel'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _agentSentAt == null
                  ? 'Ultimo envio: sin registro'
                  : 'Ultimo envio: ${_formatDateTime(_agentSentAt!)}',
            ),
            const SizedBox(height: 4),
            Text(
              _agentCompletedAt == null
                  ? 'Completado: pendiente'
                  : 'Completado: ${_formatDateTime(_agentCompletedAt!)}',
            ),
            const SizedBox(height: 10),
            if (hasUnsentChanges)
              Text(
                'Hay cambios nuevos en la configuracion. Vuelve a copiar/enviar la tarea para mantener al agente sincronizado.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.deepOrange),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: _agentTaskStatus == AgentTaskStatus.sent
                      ? () {
                          setState(() {
                            _agentTaskStatus = AgentTaskStatus.completed;
                            _agentCompletedAt = DateTime.now();
                          });
                        }
                      : null,
                  icon: const Icon(Icons.task_alt_outlined),
                  label: const Text('Marcar completado'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _agentTaskStatus = AgentTaskStatus.notSent;
                      _agentSentAt = null;
                      _agentCompletedAt = null;
                      _lastSentFingerprint = null;
                    });
                  },
                  icon: const Icon(Icons.restart_alt_outlined),
                  label: const Text('Reiniciar estado'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyText(
    BuildContext context,
    String text,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _buildDatabaseSchemaText() {
    final projectId = _projectNameController.text.trim().isEmpty
        ? 'my_final_app'
        : _projectNameController.text.trim();
    final appName = _appNameController.text.trim().isEmpty
        ? 'Mi App'
        : _appNameController.text.trim();
    final description = _appDescriptionController.text.trim().isEmpty
        ? 'Sin descripcion funcional.'
        : _appDescriptionController.text.trim();

    final lines = <String>[
      'schema_plan:',
      'project: $projectId',
      'app_name: $appName',
      'domain: ${_domainTemplate.label}',
      'database: ${_database.label}',
      'description: $description',
      'entities:',
    ];

    if (_customEntities.isEmpty) {
      lines.add('- define custom entities to generate personalized schema');
    } else {
      for (final entity in _customEntities) {
        if (_database == DatabaseOption.firestore) {
          final path = entity.parentName.isEmpty
              ? '${entity.name}/{id}'
              : '${entity.parentName}/{parentId}/${entity.name}/{id}';
          lines.add('- collection: $path');
          lines.add('  fields: ${entity.fields.join(', ')}');
        } else {
          lines.add('- table: ${entity.name}');
          lines.add('  columns: id, ${entity.fields.join(', ')}');
          if (entity.parentName.isNotEmpty) {
            lines.add('  relation: many-to-one -> ${entity.parentName}');
          }
        }
      }
    }

    lines.add('indexes:');
    lines.add('- users: createdAt DESC');
    lines.add('- core entities: ownerId/userId + createdAt DESC');
    lines.add('rules:');
    lines.add('- enforce authentication and role-based access');
    lines.add('- validate required fields before write');
    lines.add('- avoid oversized documents and unbounded arrays');
    return lines.join('\n');
  }

  String _buildFirestoreRulesTemplate() {
    return [
      'rules_version = "2";',
      'service cloud.firestore {',
      '  match /databases/{database}/documents {',
      '    function isSignedIn() { return request.auth != null; }',
      '    function isOwner(userId) { return isSignedIn() && request.auth.uid == userId; }',
      '    match /users/{userId} {',
      '      allow read: if isOwner(userId);',
      '      allow create: if isOwner(userId);',
      '      allow update: if isOwner(userId);',
      '      allow delete: if false;',
      '    }',
      '    match /orders/{orderId} {',
      '      allow read, write: if isSignedIn();',
      '    }',
      '    match /{document=**} {',
      '      allow read, write: if false;',
      '    }',
      '  }',
      '}',
    ].join('\n');
  }

  String _buildCopilotTask(String schemaText) {
    final modules = _features.toList()..sort();
    return [
      'Implementa la estructura inicial del proyecto con estos requisitos:',
      '- Proyecto: ${_projectNameController.text.trim().isEmpty ? 'my_final_app' : _projectNameController.text.trim()}',
      '- Nombre app: ${_appNameController.text.trim().isEmpty ? 'Mi App' : _appNameController.text.trim()}',
      '- Dominio: ${_domainTemplate.label}',
      '- Descripcion: ${_appDescriptionController.text.trim().isEmpty ? 'sin descripcion' : _appDescriptionController.text.trim()}',
      '- Arquitectura: ${_architecture.label}',
      '- Backend: ${_backend.label}',
      '- Base de datos: ${_database.label}',
      '- Modulos: ${modules.isEmpty ? 'ninguno' : modules.join(', ')}',
      '- Analytics: ${_needsAnalytics ? 'si' : 'no'}',
      '- Notifications: ${_needsNotifications ? 'si' : 'no'}',
      '- Entidades personalizadas: ${_customEntities.isEmpty ? 'ninguna' : _customEntities.map((e) => e.name).join(', ')}',
      'Tareas de codigo:',
      '1. Crear carpetas base por feature (data/domain/presentation).',
      '2. Crear modelos, mappers y repositorios segun entidades personalizadas.',
      '3. Agregar servicios de acceso a base de datos con manejo de errores.',
      '4. Agregar archivo de reglas iniciales y documentar indices requeridos.',
      '5. Crear tests unitarios minimos para repositorios y mappers.',
      '6. Confirmar en chat cuando la implementacion termine y listar archivos creados.',
      'Esquema recomendado:',
      schemaText,
    ].join('\n');
  }

  void _applyDomainTemplate() {
    switch (_domainTemplate) {
      case DomainTemplate.business:
        _features
          ..clear()
          ..addAll(<String>{'Auth', 'Dashboard', 'Roles & Admin', 'Reports'});
        _customEntities
          ..clear()
          ..addAll(<DbEntityDefinition>[
            DbEntityDefinition(
              name: 'businesses',
              fields: <String>['name', 'ownerId', 'industry', 'createdAt'],
              parentName: '',
            ),
            DbEntityDefinition(
              name: 'branches',
              fields: <String>['name', 'city', 'managerId', 'createdAt'],
              parentName: 'businesses',
            ),
            DbEntityDefinition(
              name: 'employees',
              fields: <String>['name', 'email', 'role', 'active'],
              parentName: 'businesses',
            ),
          ]);
      case DomainTemplate.courses:
        _features
          ..clear()
          ..addAll(<String>{'Auth', 'Dashboard', 'Reports'});
        _customEntities
          ..clear()
          ..addAll(<DbEntityDefinition>[
            DbEntityDefinition(
              name: 'courses',
              fields: <String>['title', 'description', 'level', 'createdAt'],
              parentName: '',
            ),
            DbEntityDefinition(
              name: 'modules',
              fields: <String>['title', 'order', 'durationMinutes'],
              parentName: 'courses',
            ),
            DbEntityDefinition(
              name: 'lessons',
              fields: <String>['title', 'videoUrl', 'order'],
              parentName: 'courses',
            ),
            DbEntityDefinition(
              name: 'enrollments',
              fields: <String>['userId', 'courseId', 'progress', 'status'],
              parentName: '',
            ),
          ]);
      case DomainTemplate.gym:
        _features
          ..clear()
          ..addAll(<String>{'Auth', 'Dashboard', 'Payments', 'Reports'});
        _customEntities
          ..clear()
          ..addAll(<DbEntityDefinition>[
            DbEntityDefinition(
              name: 'gyms',
              fields: <String>['name', 'ownerId', 'createdAt'],
              parentName: '',
            ),
            DbEntityDefinition(
              name: 'members',
              fields: <String>['name', 'email', 'planType', 'active'],
              parentName: 'gyms',
            ),
            DbEntityDefinition(
              name: 'plans',
              fields: <String>['name', 'price', 'durationDays'],
              parentName: 'gyms',
            ),
            DbEntityDefinition(
              name: 'workouts',
              fields: <String>['title', 'trainerId', 'difficulty'],
              parentName: 'gyms',
            ),
          ]);
      case DomainTemplate.custom:
        _features.clear();
    }
  }

  void _addCustomEntity() {
    final name = _entityNameController.text.trim();
    final fieldsText = _entityFieldsController.text.trim();
    final parentName = _entityParentController.text.trim();
    final fields = fieldsText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    if (name.isEmpty || fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes ingresar nombre y al menos un campo.'),
        ),
      );
      return;
    }

    final alreadyExists = _customEntities.any(
      (entity) => entity.name.toLowerCase() == name.toLowerCase(),
    );
    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe una entidad con ese nombre.')),
      );
      return;
    }

    if (parentName.isNotEmpty && !_entityExists(parentName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La entidad padre "$parentName" no existe.')),
      );
      return;
    }

    setState(() {
      _customEntities.add(
        DbEntityDefinition(name: name, fields: fields, parentName: parentName),
      );
      _entityNameController.clear();
      _entityFieldsController.clear();
      _entityParentController.clear();
    });
  }

  void _removeCustomEntityAt(int index) {
    final deletedName = _customEntities[index].name;
    setState(() {
      _customEntities.removeAt(index);
      // Any child pointing to a removed parent is detached automatically.
      for (var i = 0; i < _customEntities.length; i++) {
        final entity = _customEntities[i];
        if (entity.parentName == deletedName) {
          _customEntities[i] = entity.copyWith(parentName: '');
        }
      }
    });
  }

  void _reorderCustomEntities(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _customEntities.removeAt(oldIndex);
      _customEntities.insert(newIndex, item);
    });
  }

  void _linkEntityToParent(String childName, String parentName) {
    if (childName == parentName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Una entidad no puede ser padre de si misma.'),
        ),
      );
      return;
    }

    if (!_entityExists(childName) || !_entityExists(parentName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Relacion invalida: entidad no encontrada.'),
        ),
      );
      return;
    }

    final childIndex = _customEntities.indexWhere((e) => e.name == childName);
    if (childIndex < 0) {
      return;
    }

    if (_wouldCreateCycle(childName: childName, newParentName: parentName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Relacion no permitida: se detecto ciclo en el grafo de entidades.',
          ),
        ),
      );
      return;
    }

    setState(() {
      final child = _customEntities[childIndex];
      _customEntities[childIndex] = child.copyWith(parentName: parentName);
    });
  }

  void _unlinkEntityParent(String childName) {
    final childIndex = _customEntities.indexWhere((e) => e.name == childName);
    if (childIndex < 0) {
      return;
    }

    setState(() {
      final child = _customEntities[childIndex];
      _customEntities[childIndex] = child.copyWith(parentName: '');
    });
  }

  Future<void> _editCustomEntity(int index) async {
    final current = _customEntities[index];
    final nameController = TextEditingController(text: current.name);
    final fieldsController = TextEditingController(
      text: current.fields.join(', '),
    );
    final parentController = TextEditingController(text: current.parentName);

    final updated = await showDialog<DbEntityDefinition>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar entidad personalizada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fieldsController,
                  decoration: const InputDecoration(
                    labelText: 'Campos (coma o nombre:tipo)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: parentController,
                  decoration: const InputDecoration(
                    labelText: 'Padre (opcional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final updatedName = nameController.text.trim();
                final updatedFields = fieldsController.text
                    .split(',')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .toList();
                final updatedParent = parentController.text.trim();

                if (updatedName.isEmpty || updatedFields.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(
                  DbEntityDefinition(
                    name: updatedName,
                    fields: updatedFields,
                    parentName: updatedParent,
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    fieldsController.dispose();
    parentController.dispose();

    if (updated == null) {
      return;
    }

    final duplicatedName = _customEntities.asMap().entries.any(
      (entry) =>
          entry.key != index &&
          entry.value.name.toLowerCase() == updated.name.toLowerCase(),
    );

    if (duplicatedName) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe una entidad con ese nombre.')),
      );
      return;
    }

    if (updated.parentName.isNotEmpty && !_entityExists(updated.parentName)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La entidad padre "${updated.parentName}" no existe para ${updated.name}.',
          ),
        ),
      );
      return;
    }

    if (updated.parentName == updated.name) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Una entidad no puede ser padre de si misma.'),
        ),
      );
      return;
    }

    if (updated.parentName.isNotEmpty &&
        _wouldCreateCycle(
          childName: updated.name,
          newParentName: updated.parentName,
          editingIndex: index,
          replacement: updated,
        )) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Relacion invalida: crearia un ciclo entre entidades.'),
        ),
      );
      return;
    }

    setState(() {
      final previousName = _customEntities[index].name;
      _customEntities[index] = updated;
      if (previousName != updated.name) {
        for (var i = 0; i < _customEntities.length; i++) {
          if (i == index) {
            continue;
          }
          final entity = _customEntities[i];
          if (entity.parentName == previousName) {
            _customEntities[i] = entity.copyWith(parentName: updated.name);
          }
        }
      }
    });
  }

  bool _entityExists(String name) {
    return _customEntities.any((entity) => entity.name == name);
  }

  DbEntityDefinition? _entityFromList(
    List<DbEntityDefinition> source,
    String name,
  ) {
    for (final entity in source) {
      if (entity.name == name) {
        return entity;
      }
    }
    return null;
  }

  bool _wouldCreateCycle({
    required String childName,
    required String newParentName,
    int? editingIndex,
    DbEntityDefinition? replacement,
  }) {
    final working = <DbEntityDefinition>[..._customEntities];

    if (editingIndex != null && replacement != null) {
      working[editingIndex] = replacement;
    }

    final childIndex = working.indexWhere((entity) => entity.name == childName);
    if (childIndex < 0) {
      return false;
    }

    working[childIndex] = working[childIndex].copyWith(
      parentName: newParentName,
    );

    String current = newParentName;
    final visited = <String>{childName};

    while (current.isNotEmpty) {
      if (visited.contains(current)) {
        return true;
      }
      visited.add(current);

      final currentEntity = _entityFromList(working, current);
      if (currentEntity == null) {
        return false;
      }
      final next = currentEntity.parentName;
      if (next.isEmpty) {
        return false;
      }
      current = next;
    }

    return false;
  }

  String _buildConfigFingerprint(String payload) {
    return payload.hashCode.toUnsigned(32).toRadixString(16).padLeft(8, '0');
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  List<RecommendationItem> _buildRecommendations() {
    final items = <RecommendationItem>[
      RecommendationItem(
        icon: Icons.rule_folder_outlined,
        color: Colors.blue,
        title: 'Define convenciones de módulos desde el inicio',
        description:
            'Usa plantillas por feature para evitar deuda técnica y acelerar onboarding.',
      ),
    ];

    if (_database == DatabaseOption.firestore &&
        _features.contains('Reports')) {
      items.add(
        RecommendationItem(
          icon: Icons.insights_outlined,
          color: Colors.deepOrange,
          title: 'Combina Firestore con BigQuery para reportes',
          description:
              'Firestore es ideal para tiempo real; para analítica compleja usa pipeline a BigQuery.',
        ),
      );
    }

    if (_features.contains('Payments')) {
      items.add(
        RecommendationItem(
          icon: Icons.payments_outlined,
          color: Colors.green,
          title: 'Aisla pagos en un bounded context',
          description:
              'Implementa idempotencia, auditoría y webhooks con reintentos controlados.',
        ),
      );
    }

    if (_features.contains('Offline Mode') &&
        _database == DatabaseOption.mysql) {
      items.add(
        RecommendationItem(
          icon: Icons.sync_problem_outlined,
          color: Colors.purple,
          title: 'Agrega capa de sincronización incremental',
          description:
              'Define estrategia de conflictos (last write wins o versionado) para operación offline.',
        ),
      );
    }

    if (_needsAnalytics) {
      items.add(
        RecommendationItem(
          icon: Icons.monitor_heart_outlined,
          color: Colors.teal,
          title: 'Instrumenta métricas de negocio y técnicas',
          description:
              'Mide funnels, crash-free sessions y latencia por endpoint para mejorar calidad.',
        ),
      );
    }

    final teamSize = int.tryParse(_teamSizeController.text.trim()) ?? 1;
    if (teamSize >= 6) {
      items.add(
        RecommendationItem(
          icon: Icons.groups_2_outlined,
          color: Colors.indigo,
          title: 'Formaliza ADRs y ownership por dominios',
          description:
              'Con equipos medianos/grandes, documentar decisiones reduce bloqueos y retrabajo.',
        ),
      );
    }

    return items;
  }
}

class RecommendationItem {
  const RecommendationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}

enum AppType { mobile, web, multiplatform }

extension AppTypeLabel on AppType {
  String get label {
    switch (this) {
      case AppType.mobile:
        return 'Mobile';
      case AppType.web:
        return 'Web';
      case AppType.multiplatform:
        return 'Multiplataforma';
    }
  }
}

enum BackendOption { firebase, supabase, customApi }

extension BackendOptionLabel on BackendOption {
  String get label {
    switch (this) {
      case BackendOption.firebase:
        return 'Firebase';
      case BackendOption.supabase:
        return 'Supabase';
      case BackendOption.customApi:
        return 'Custom API (Node/Nest/Go)';
    }
  }
}

enum DatabaseOption { firestore, postgres, mysql }

extension DatabaseOptionLabel on DatabaseOption {
  String get label {
    switch (this) {
      case DatabaseOption.firestore:
        return 'Firestore';
      case DatabaseOption.postgres:
        return 'PostgreSQL';
      case DatabaseOption.mysql:
        return 'MySQL';
    }
  }
}

enum ArchitectureOption { cleanArchitecture, mvvm, modularMonolith }

extension ArchitectureOptionLabel on ArchitectureOption {
  String get label {
    switch (this) {
      case ArchitectureOption.cleanArchitecture:
        return 'Clean Architecture';
      case ArchitectureOption.mvvm:
        return 'MVVM';
      case ArchitectureOption.modularMonolith:
        return 'Modular Monolith';
    }
  }
}

enum DeploymentOption { cloudRun, awsEcs, digitalOcean }

extension DeploymentOptionLabel on DeploymentOption {
  String get label {
    switch (this) {
      case DeploymentOption.cloudRun:
        return 'Google Cloud Run';
      case DeploymentOption.awsEcs:
        return 'AWS ECS';
      case DeploymentOption.digitalOcean:
        return 'DigitalOcean Apps';
    }
  }
}

enum DomainTemplate { business, courses, gym, custom }

extension DomainTemplateLabel on DomainTemplate {
  String get label {
    switch (this) {
      case DomainTemplate.business:
        return 'business';
      case DomainTemplate.courses:
        return 'courses';
      case DomainTemplate.gym:
        return 'gym';
      case DomainTemplate.custom:
        return 'custom';
    }
  }
}

enum AgentTaskStatus { notSent, sent, completed }
