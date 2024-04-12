import 'package:flutter/material.dart';

import '../../core/themes/app_theme_factory.dart';
import '../extensions/build_context_extensions.dart';

class CustomTooltip extends StatelessWidget {
  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode,
  });

  final String message;
  final Widget child;
  final TooltipTriggerMode? triggerMode;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      verticalOffset: 0,
      excludeFromSemantics: true,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: context.theme.borderRadiusSM,
      ),
      textStyle: context.textTheme.bodyMedium,
      enableFeedback: true,
      triggerMode: triggerMode,
      child: child,
    );
  }
}
