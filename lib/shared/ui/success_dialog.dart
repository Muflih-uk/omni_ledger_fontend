import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';

class SuccessAction {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const SuccessAction({
    required this.label,
    this.onTap,
    this.isPrimary = true,
  });
}

Future<void> showAppSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  List<SuccessAction> actions = const [],
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppSuccessDialog(
      title: title,
      message: message,
      actions: actions,
    ),
  );
}

class AppSuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final List<SuccessAction> actions;

  const AppSuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.actions = const [],
  });

  @override
  State<AppSuccessDialog> createState() => _AppSuccessDialogState();
}

class _AppSuccessDialogState extends State<AppSuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handle(SuccessAction action) {
    Navigator.of(context).pop();
    action.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    final fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.4, end: 1.0).animate(scale),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppConstants.successColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                for (final action in widget.actions) ...[
                  AppTextButton(
                    text: action.label,
                    backgroundColor: action.isPrimary
                        ? AppConstants.primaryColor
                        : AppConstants.containerColor,
                    textColor: action.isPrimary
                        ? Colors.white
                        : AppConstants.primaryColor,
                    onPressed: () => _handle(action),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}