import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../data/models/request_models.dart';
import '../data/models/response_models.dart';
import 'feature_toggles_controller.dart';

void showIsUserInFeatureDialog(
  BuildContext context, {
  required FeatureTogglesController controller,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => _IsUserInFeatureDialog(controller: controller),
  );
}

class _IsUserInFeatureDialog extends StatefulWidget {
  const _IsUserInFeatureDialog({required this.controller});

  final FeatureTogglesController controller;

  @override
  State<_IsUserInFeatureDialog> createState() => _IsUserInFeatureDialogState();
}

class _IsUserInFeatureDialogState extends State<_IsUserInFeatureDialog> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _namespaceController = TextEditingController();
  final _platformController = TextEditingController(text: 'ios');

  bool _isChecking = false;
  String? _error;
  List<Feature>? _features;

  @override
  void dispose() {
    _userIdController.dispose();
    _namespaceController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isChecking = true;
      _error = null;
      _features = null;
    });
    try {
      final reply = await widget.controller.isUserInFeature(
        IsUserInFeatureRequest(
          userId: int.parse(_userIdController.text.trim()),
          namespace: _namespaceController.text.trim(),
          platform: _platformController.text.trim(),
        ),
      );
      setState(() {
        _isChecking = false;
        if (reply.isOk) {
          _features = reply.features;
        } else {
          _error = reply.message.isNotEmpty ? reply.message : 'Не удалось проверить';
        }
      });
    } on ApiException catch (e) {
      setState(() {
        _isChecking = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Проверить фичи пользователя'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _userIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ID пользователя'),
                  validator: (v) =>
                      int.tryParse(v?.trim() ?? '') == null ? 'Введите число' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _namespaceController,
                  decoration: const InputDecoration(labelText: 'Namespace (например mobile_app)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Укажите namespace' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _platformController,
                  decoration: const InputDecoration(labelText: 'Платформа (ios/android/web)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Укажите платформу' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                if (_features != null) ...[
                  const SizedBox(height: 16),
                  if (_features!.isEmpty)
                    const Text('Ни одна фича не включена для этого пользователя')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _features!
                          .map((f) => Chip(label: Text('${f.featureName} (#${f.featureId})')))
                          .toList(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
        FilledButton(
          onPressed: _isChecking ? null : _check,
          child: _isChecking
              ? const SizedBox(
                  width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Проверить'),
        ),
      ],
    );
  }
}
