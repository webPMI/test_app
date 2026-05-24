import 'package:flutter/material.dart';
import 'language_keys.dart';

class Tr {
  Tr(this.locale);
  final Locale locale;

  Map<String, String> get _map {
    switch (locale.languageCode) {
      case 'es':
        return spanish;
      case 'en':
        return english;
      default:
        return english;
    }
  }
  String call (String key, {Map<String,String>?params}){
    if(!_map.containsKey(key)){
return key;
    }else{
var value = _map[key]!;
if (params != null && params.isNotEmpty){
  params.forEach((k, v){
    value = value.replaceAll('{$k}', v);
  });
}
return value;
    }
  }
    /// Static method for translation.
  ///
  /// Useful when a [BuildContext] is not available.
  static String of(Locale locale, String key, {Map<String, String>? params}) {
    return Tr(locale).call(key, params: params);
  }
}
