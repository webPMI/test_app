import 'package:flutter/material.dart';

class ReactiveBody extends StatelessWidget {
  const ReactiveBody({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    double horizontalPadding = 16.0;
    double verticalPadding = 24.0;
    double maxWidth = 800.0;

    if (width >= 1024) {
      horizontalPadding = 32.0;
      verticalPadding = 40.0;
      maxWidth = 900.0;
    } else if (width >= 600) {
      horizontalPadding = 24.0;
      verticalPadding = 32.0;
      maxWidth = 750.0;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
