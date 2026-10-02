import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../data/models/models.dart';
import 'custom_params_controller.dart';

/// The gateway's own example payload only ever shows `type: "STRING"`, and
/// nothing in the openapi spec enumerates the full set of allowed types —
/// these are a reasonable guess at what a condition-based custom param
/// would need, not a confirmed list. Swap in the real set once you've
/// checked the backend's validator.
const _knownParamTypes = ['STRING', 'INT', 'FLOAT', 'BOOL'];

Future<bool?> showCreateCustomParamDialog(
  BuildContext context, {
  required CustomParamsController controller,
  required List<GetNamespace> namespaces,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  GetNamespace? selectedNamespace = namespaces.isEmpty ? null : namespaces.first;
  String selectedType = _knownParamTypes.first;

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => FormDialog(
        title: 'Новый кастомный параметр',
        formKey: formKey,
        submitLabel: 'Создать',
        onSubmit: () {
          if (selectedNamespace == null) {
            return Future.value('Сначала создайте неймспейс');
          }
          return controller.create(
            CreateCustomParamRequest(
              name: nameController.text.trim(),
              namespaceId: selectedNamespace!.id,
              type: selectedType,
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
              decoration: const InputDecoration(labelText: 'Название параметра'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Укажите название' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(labelText: 'Тип'),
              items: _knownParamTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (value) => setState(() => selectedType = value ?? selectedType),
            ),
          ],
        ),
      ),
    ),
  );
}
