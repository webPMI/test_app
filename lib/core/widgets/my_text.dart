import 'package:flutter/material.dart';

import '../language/language_context.dart';

class MyText extends StatelessWidget {
  const MyText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.tr(text),
      style: style ?? TextStyle(color: Theme.of(context).primaryColor),
    );
  }
}
