import 'package:flutter/material.dart';

import '../routing/navigation_service.dart';
import '../widgets/common_bottom_sheets.dart';

class AppFeedback {
  AppFeedback._();

  static Future<void> showErrorSheet(
    String message, {
    String title = 'Something went wrong',
  }) async {
    final context = NavigationService.context;
    if (context == null) return;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => buildErrorSheet(
        title: title,
        description: message,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Future<void> showSuccessSheet(
    String title,
    String description, {
    String actionText = 'OK',
    VoidCallback? onAction,
  }) async {
    final context = NavigationService.context;
    if (context == null) return;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => buildSuccessSheet(
        title: title,
        description: description,
        actionText: actionText,
        onAction: () {
          Navigator.of(context).pop();
          onAction?.call();
        },
      ),
    );
  }
}
