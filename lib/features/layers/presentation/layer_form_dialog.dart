import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../data/models/models.dart';
import 'layers_controller.dart';

Future<bool?> showCreateLayerDialog(
  BuildContext context, {
  required LayersController controller,
  required List<GetNamespace> namespaces,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  GetNamespace? selectedNamespace = namespaces.isEmpty ? null : namespaces.first;

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => FormDialog(
        title: 'Новый слой',
        formKey: formKey,
        submitLabel: 'Создать',
        onSubmit: () {
          if (selectedNamespace == null) {
            return Future.value('Сначала создайте неймспейс');
          }
          return controller.create(
            CreateLayerRequest(
              namespaceId: selectedNamespace!.id,
              name: nameController.text.trim(),
              description: descriptionController.text.trim().isEmpty
                  ? null
                  : descriptionController.text.trim(),
            ),
          );
        },
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<GetNamespace>(
              initialValue: selectedNamespace,
              decoration: const InputDecoration(labelText: 'Неймспейс'),
              items: namespaces
                  .map((n) => DropdownMenuItem(value: n, child: Text(n.name)))
                  .toList(),
              onChanged: (value) => setState(() => selectedNamespace = value),
            ),
            const SizedBox(height: 12),
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
    ),
  );
}
