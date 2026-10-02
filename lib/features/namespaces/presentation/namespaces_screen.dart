import 'package:flutter/material.dart';

import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../data/models/models.dart';
import 'namespace_form_dialog.dart';
import 'namespaces_controller.dart';

class NamespacesScreen extends StatelessWidget {
  const NamespacesScreen({super.key, required this.controller});

  final NamespacesController controller;

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Неймспейсы',
      subtitle: 'Пространства, в которых живут слои и эксперименты',
      onAdd: () => showCreateNamespaceDialog(context, controller),
      child: AsyncListView<GetNamespace>(
        controller: controller.list,
        emptyLabel: 'Неймспейсов пока нет',
        itemBuilder: (context, namespace) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${namespace.id}')),
            title: Text(namespace.name),
            subtitle: namespace.description.isEmpty ? null : Text(namespace.description),
          ),
        ),
      ),
    );
  }
}
