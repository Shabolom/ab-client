import 'package:flutter/material.dart';

import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../../namespaces/presentation/namespaces_controller.dart';
import '../data/models/models.dart';
import 'layer_form_dialog.dart';
import 'layers_controller.dart';

class LayersScreen extends StatelessWidget {
  const LayersScreen({
    super.key,
    required this.controller,
    required this.namespaces,
  });

  final LayersController controller;
  final NamespacesController namespaces;

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Слои',
      subtitle: 'Слои внутри неймспейсов, на которые опираются эксперименты',
      onAdd: () {
        if (namespaces.list.items.isEmpty) {
          AppSnack.error(context, 'Сначала создайте хотя бы один неймспейс');
          return;
        }
        showCreateLayerDialog(
          context,
          controller: controller,
          namespaces: namespaces.list.items,
        );
      },
      child: AsyncListView<GetLayer>(
        controller: controller.list,
        emptyLabel: 'Слоёв пока нет',
        itemBuilder: (context, layer) {
          final namespaceName = namespaces.list.items
              .cast<GetNamespace?>()
              .firstWhere((n) => n?.id == layer.namespaceId, orElse: () => null)
              ?.name;
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${layer.id}')),
              title: Text(layer.name),
              subtitle: Text(
                [
                  if (namespaceName != null) namespaceName,
                  if (layer.description.isNotEmpty) layer.description,
                ].join(' · '),
              ),
            ),
          );
        },
      ),
    );
  }
}
