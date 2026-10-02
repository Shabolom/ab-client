import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../../../common/widgets/rollout_slider.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../data/models/request_models.dart';
import 'feature_toggles_controller.dart';

Future<bool?> showCreateFeatureToggleDialog(
  BuildContext context, {
  required FeatureTogglesController controller,
  required List<GetNamespace> namespaces,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  GetNamespace? selectedNamespace = namespaces.isEmpty ? null : namespaces.first;
  double rollout = 0;
  double iosRollout = 0;
  double androidRollout = 0;
  double webRollout = 0;

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => FormDialog(
        title: 'Новый фича-тоггл',
        formKey: formKey,
        submitLabel: 'Создать',
        onSubmit: () {
          if (selectedNamespace == null) {
            return Future.value('Сначала создайте неймспейс');
          }
          return controller.create(
            CreateFeatureToggleRequest(
              name: nameController.text.trim(),
              namespaceId: selectedNamespace!.id,
              rolloutPercentage: rollout.round(),
              iosRolloutPercentage: iosRollout.round(),
              androidRolloutPercentage: androidRollout.round(),
              webRolloutPercentage: webRollout.round(),
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
            const SizedBox(height: 8),
            RolloutSlider(
              label: 'Общий rollout',
              value: rollout,
              onChanged: (v) => setState(() => rollout = v),
            ),
            RolloutSlider(
              label: 'iOS',
              value: iosRollout,
              onChanged: (v) => setState(() => iosRollout = v),
            ),
            RolloutSlider(
              label: 'Android',
              value: androidRollout,
              onChanged: (v) => setState(() => androidRollout = v),
            ),
            RolloutSlider(
              label: 'Web',
              value: webRollout,
              onChanged: (v) => setState(() => webRollout = v),
            ),
          ],
        ),
      ),
    ),
  );
}
