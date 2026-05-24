import 'package:flutter/material.dart';

class LanguageState {
  const LanguageState(this.language);
  final Locale language;

  @override
  String toString() => 'LanguageState($language)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageState &&
          runtimeType == other.runtimeType &&
          language == other.language;

  @override
  int get hashCode => language.hashCode;
}
