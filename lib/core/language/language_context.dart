import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/language_bloc.dart';
import 'language_translation.dart';

extension TranslateX on BuildContext {
  String tr(String key, {Map<String, String>? args}) {
    final locale = watch<LanguageCubit>().state.language;
    return Tr(locale).call(key, params: args);
  }
}
