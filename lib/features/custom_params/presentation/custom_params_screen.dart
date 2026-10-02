import 'package:flutter/material.dart';

import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../../namespaces/presentation/namespaces_controller.dart';
import '../data/models/models.dart';
import 'custom_param_form_dialog.dart';
import 'custom_params_controller.dart';

class CustomParamsScreen extends StatelessWidget {
  const CustomParamsScreen({
    super.key,
    required this.controller,
    required this.namespaces,
  });

  final CustomParamsController controller;
  final NamespacesController namespaces;

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Кастомные параметры',
      subtitle: 'Параметры для таргетинга групп в экспериментах',
      onAdd: () {
        if (namespaces.list.items.isEmpty) {
          AppSnack.error(context, 'Сначала создайте хотя бы один неймспейс');
          return;
        }
        showCreateCustomParamDialog(
          context,
          controller: controller,
          namespaces: namespaces.list.items,
        );
      },
      child: AsyncListView<GetCustomParam>(
        controller: controller.list,
        emptyLabel: 'Параметров пока нет',
        itemBuilder: (context, param) {
          final namespaceName = namespaces.list.items
              .cast<GetNamespace?>()
              .firstWhere((n) => n?.id == param.namespaceId, orElse: () => null)
              ?.name;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: Text(param.name),
              subtitle: Text([
                if (namespaceName != null) namespaceName,
                param.type,
              ].join(' · ')),
              trailing: Text('#${param.id}'),
            ),
          );
        },
      ),
    );
  }
}
