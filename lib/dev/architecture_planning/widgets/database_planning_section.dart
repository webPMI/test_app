import 'package:flutter/material.dart';

import '../models/db_entity_definition.dart';

enum SchemaVisualizationMode { graph, table, text }

class DatabasePlanningSection extends StatefulWidget {
  const DatabasePlanningSection({
    super.key,
    required this.isFirestore,
    required this.customEntities,
    required this.entityNameController,
    required this.entityFieldsController,
    required this.entityParentController,
    required this.schemaText,
    required this.onAddEntity,
    required this.onEditEntity,
    required this.onDeleteEntity,
    required this.onReorderEntities,
    required this.onLinkParent,
    required this.onUnlinkParent,
    required this.onCopySchema,
    required this.onCopyRules,
  });

  final bool isFirestore;
  final List<DbEntityDefinition> customEntities;
  final TextEditingController entityNameController;
  final TextEditingController entityFieldsController;
  final TextEditingController entityParentController;
  final String schemaText;
  final VoidCallback onAddEntity;
  final void Function(int index) onEditEntity;
  final void Function(int index) onDeleteEntity;
  final void Function(int oldIndex, int newIndex) onReorderEntities;
  final void Function(String childName, String parentName) onLinkParent;
  final void Function(String childName) onUnlinkParent;
  final VoidCallback onCopySchema;
  final VoidCallback? onCopyRules;

  @override
  State<DatabasePlanningSection> createState() =>
      _DatabasePlanningSectionState();
}

class _DatabasePlanningSectionState extends State<DatabasePlanningSection> {
  SchemaVisualizationMode _mode = SchemaVisualizationMode.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDataModelCard(context),
        const SizedBox(height: 16),
        _buildSchemaCard(context),
      ],
    );
  }

  Widget _buildDataModelCard(BuildContext context) {
    final parentOptions = widget.customEntities.map((e) => e.name).toList();
    final selectedParent =
        parentOptions.contains(widget.entityParentController.text)
        ? widget.entityParentController.text
        : '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5) Modelo de Datos Personalizado',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              widget.isFirestore
                  ? 'Agrega colecciones y subcolecciones. Luego reordena con drag and drop y enlaza relaciones en el esquema.'
                  : 'Agrega tablas y relaciones. Luego reordena con drag and drop y valida la vista tipo tabla.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: widget.entityNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre entidad/tabla',
                hintText: 'ej: businesses, courses, members',
                prefixIcon: Icon(Icons.account_tree_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.entityFieldsController,
              decoration: const InputDecoration(
                labelText: 'Campos (coma o nombre:tipo)',
                hintText:
                    'ej: name:string, ownerId:string, createdAt:timestamp',
                prefixIcon: Icon(Icons.view_list_outlined),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey('parent-$selectedParent-${parentOptions.length}'),
              initialValue: selectedParent,
              decoration: InputDecoration(
                labelText: widget.isFirestore
                    ? 'Coleccion padre (opcional)'
                    : 'Tabla padre (opcional)',
                prefixIcon: const Icon(Icons.call_split_outlined),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('Sin padre'),
                ),
                ...parentOptions.map(
                  (name) =>
                      DropdownMenuItem<String>(value: name, child: Text(name)),
                ),
              ],
              onChanged: (value) {
                widget.entityParentController.text = value ?? '';
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.onAddEntity,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Agregar entidad personalizada'),
            ),
            const SizedBox(height: 12),
            if (widget.customEntities.isEmpty)
              Text(
                'Aun no agregaste entidades personalizadas.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.customEntities.length,
                onReorderItem: widget.onReorderEntities,
                itemBuilder: (context, index) {
                  final entity = widget.customEntities[index];
                  return Card(
                    key: ValueKey(entity.name),
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    child: ListTile(
                      title: Text(entity.name),
                      subtitle: Text(
                        'Campos: ${entity.fields.join(', ')}${entity.parentName.isEmpty ? '' : ' | Padre: ${entity.parentName}'}',
                      ),
                      leading: const Icon(Icons.drag_indicator_rounded),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => widget.onEditEntity(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => widget.onDeleteEntity(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemaCard(BuildContext context) {
    final rootCount = widget.customEntities
        .where((entity) => entity.parentName.isEmpty)
        .length;
    final relationCount = widget.customEntities
        .where((entity) => entity.parentName.isNotEmpty)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '6) Esquema de Base de Datos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Visualiza y personaliza el esquema en modo grafo (drag and drop), tabla o texto.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.schemaText,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Entidades: ${widget.customEntities.length}')),
                Chip(label: Text('Raices: $rootCount')),
                Chip(label: Text('Relaciones: $relationCount')),
                ActionChip(
                  label: const Text('Ver esquema completo'),
                  onPressed: () {
                    setState(() {
                      _mode = SchemaVisualizationMode.text;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<SchemaVisualizationMode>(
              segments: const [
                ButtonSegment<SchemaVisualizationMode>(
                  value: SchemaVisualizationMode.graph,
                  icon: Icon(Icons.hub_outlined),
                  label: Text('Grafo'),
                ),
                ButtonSegment<SchemaVisualizationMode>(
                  value: SchemaVisualizationMode.table,
                  icon: Icon(Icons.table_rows_outlined),
                  label: Text('Tabla'),
                ),
                ButtonSegment<SchemaVisualizationMode>(
                  value: SchemaVisualizationMode.text,
                  icon: Icon(Icons.notes_outlined),
                  label: Text('Texto'),
                ),
              ],
              selected: <SchemaVisualizationMode>{_mode},
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_mode == SchemaVisualizationMode.graph)
              _buildGraphView(context),
            if (_mode == SchemaVisualizationMode.table)
              _buildTableView(context),
            if (_mode == SchemaVisualizationMode.text) _buildTextView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphView(BuildContext context) {
    if (widget.customEntities.isEmpty) {
      return Text(
        'Agrega entidades para visualizar el grafo de relaciones.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Arrastra una entidad y sueltala sobre otra para asignar padre.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.customEntities.map((entity) {
            return DragTarget<String>(
              onWillAcceptWithDetails: (details) =>
                  details.data != entity.name && details.data.isNotEmpty,
              onAcceptWithDetails: (details) {
                widget.onLinkParent(details.data, entity.name);
              },
              builder: (context, candidateData, rejectedData) {
                final isActiveTarget = candidateData.isNotEmpty;
                return LongPressDraggable<String>(
                  data: entity.name,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _EntityNode(
                      name: entity.name,
                      parentName: entity.parentName,
                      fieldCount: entity.fields.length,
                      isTarget: true,
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.4,
                    child: _EntityNode(
                      name: entity.name,
                      parentName: entity.parentName,
                      fieldCount: entity.fields.length,
                      isTarget: false,
                    ),
                  ),
                  child: _EntityNode(
                    name: entity.name,
                    parentName: entity.parentName,
                    fieldCount: entity.fields.length,
                    isTarget: isActiveTarget,
                    onUnlink: entity.parentName.isNotEmpty
                        ? () => widget.onUnlinkParent(entity.name)
                        : null,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTableView(BuildContext context) {
    if (widget.customEntities.isEmpty) {
      return Text(
        'No hay datos para tabla. Agrega al menos una entidad.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Entidad')),
          DataColumn(label: Text('Padre')),
          DataColumn(label: Text('Campos tipados')),
          DataColumn(label: Text('PK/FK sugerida')),
          DataColumn(label: Text('Cantidad')),
        ],
        rows: widget.customEntities.map((entity) {
          final typedFields = entity.fields
              .map((field) => _parseField(field))
              .map((pair) => '${pair.$1}:${pair.$2}')
              .join(', ');
          final pkFk = entity.parentName.isEmpty
              ? 'id'
              : 'id, ${entity.parentName}Id';

          return DataRow(
            cells: [
              DataCell(Text(entity.name)),
              DataCell(
                Text(entity.parentName.isEmpty ? '-' : entity.parentName),
              ),
              DataCell(SizedBox(width: 360, child: Text(typedFields))),
              DataCell(Text(pkFk)),
              DataCell(Text(entity.fields.length.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            widget.schemaText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            FilledButton.icon(
              onPressed: widget.onCopySchema,
              icon: const Icon(Icons.copy_all_rounded),
              label: const Text('Copiar esquema'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: widget.onCopyRules,
              icon: const Icon(Icons.gavel_rounded),
              label: const Text('Copiar rules base'),
            ),
          ],
        ),
      ],
    );
  }
}

class _EntityNode extends StatelessWidget {
  const _EntityNode({
    required this.name,
    required this.parentName,
    required this.fieldCount,
    required this.isTarget,
    this.onUnlink,
  });

  final String name;
  final String parentName;
  final int fieldCount;
  final bool isTarget;
  final VoidCallback? onUnlink;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 210,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isTarget
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTarget
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dataset_linked_outlined, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            parentName.isEmpty ? 'Raiz' : 'Padre: $parentName',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Campos: $fieldCount',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (onUnlink != null)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onUnlink,
                icon: const Icon(Icons.link_off_outlined, size: 18),
                tooltip: 'Quitar padre',
              ),
            ),
        ],
      ),
    );
  }
}

(String, String) _parseField(String rawField) {
  final parts = rawField.split(':');
  if (parts.length == 1) {
    return (parts.first.trim(), 'string');
  }

  final name = parts.first.trim();
  final type = parts.sublist(1).join(':').trim();
  return (name, type.isEmpty ? 'string' : type);
}
