import 'package:flutter/material.dart';

/// A consistent shell for "create/edit X" dialogs: title, scrollable form
/// body, an inline error banner, and Cancel/Submit actions that disable
/// themselves while [onSubmit] is in flight so a slow request can't be
/// fired twice by an impatient double-tap.
///
/// [onSubmit] returns the error message on failure, or `null` on success
/// (in which case the dialog closes itself).
class FormDialog extends StatefulWidget {
  const FormDialog({
    super.key,
    required this.title,
    required this.formKey,
    required this.builder,
    required this.onSubmit,
    this.submitLabel = 'Сохранить',
    this.width = 480,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final WidgetBuilder builder;
  final Future<String?> Function() onSubmit;
  final String submitLabel;
  final double width;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  bool _isSubmitting = false;
  String? _error;

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    if (!(widget.formKey.currentState?.validate() ?? true)) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final error = await widget.onSubmit();
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isSubmitting = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: widget.width,
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.builder(context),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.submitLabel),
        ),
      ],
    );
  }
}
