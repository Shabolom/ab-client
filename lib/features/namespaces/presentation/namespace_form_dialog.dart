import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../data/models/models.dart';
import 'namespaces_controller.dart';

Future<bool?> showCreateNamespaceDialog(
  BuildContext context,
  NamespacesController controller,
) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  return showDialog<bool>(
    context: context,
    builder: (context) => FormDialog(
      title: 'Новый неймспейс',
      formKey: formKey,
      submitLabel: 'Создать',
      onSubmit: () => controller.create(
        CreateNamespaceRequest(
          name: nameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        ),
      ),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Название'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Укажите название' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}
