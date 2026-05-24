class DbEntityDefinition {
  const DbEntityDefinition({
    required this.name,
    required this.fields,
    required this.parentName,
  });

  final String name;
  final List<String> fields;
  final String parentName;

  DbEntityDefinition copyWith({
    String? name,
    List<String>? fields,
    String? parentName,
  }) {
    return DbEntityDefinition(
      name: name ?? this.name,
      fields: fields ?? this.fields,
      parentName: parentName ?? this.parentName,
    );
  }
}
