import 'package:flutter/material.dart';

import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../../namespaces/data/models/models.dart' show GetNamespace;
import '../../namespaces/presentation/namespaces_controller.dart';
import '../data/models/feature_toggle_status.dart';
import '../data/models/response_models.dart';
import 'feature_toggle_form_dialog.dart';
import 'feature_toggle_rollout_dialog.dart';
import 'feature_toggles_controller.dart';
import 'is_user_in_feature_dialog.dart';

class FeatureTogglesScreen extends StatelessWidget {
  const FeatureTogglesScreen({
    super.key,
    required this.controller,
    required this.namespaces,
  });

  final FeatureTogglesController controller;
  final NamespacesController namespaces;

  Future<void> _changeStatus(
    BuildContext context,
    GetFeatureToggle toggle,
    FeatureToggleStatus status,
  ) async {
    final error = await controller.setStatus(toggle.id, status);
    if (!context.mounted) return;
    if (error != null) {
      AppSnack.error(context, error);
    } else {
      AppSnack.success(context, 'Статус обновлён');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Фича-тогглы',
      subtitle: 'Постепенный rollout функциональности по платформам',
      trailing: OutlinedButton.icon(
        onPressed: () => showIsUserInFeatureDialog(context, controller: controller),
        icon: const Icon(Icons.person_search),
        label: const Text('Проверить пользователя'),
      ),
      onAdd: () {
        if (namespaces.list.items.isEmpty) {
          AppSnack.error(context, 'Сначала создайте хотя бы один неймспейс');
          return;
        }
        showCreateFeatureToggleDialog(
          context,
          controller: controller,
          namespaces: namespaces.list.items,
        );
      },
      child: AsyncListView<GetFeatureToggle>(
        controller: controller.list,
        emptyLabel: 'Фича-тогглов пока нет',
        itemBuilder: (context, toggle) {
          final namespaceName = namespaces.list.items
              .cast<GetNamespace?>()
              .firstWhere((n) => n?.id == toggle.namespaceId, orElse: () => null)
              ?.name;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(toggle.name,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      _StatusMenu(
                        status: toggle.status,
                        onSelected: (status) => _changeStatus(context, toggle, status),
                      ),
                    ],
                  ),
                  if (namespaceName != null)
                    Text(namespaceName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            )),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _rolloutChip('Общий', toggle.rolloutPercentage),
                      _rolloutChip('iOS', toggle.ios),
                      _rolloutChip('Android', toggle.android),
                      _rolloutChip('Web', toggle.web),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => showEditRolloutDialog(
                        context,
                        controller: controller,
                        toggle: toggle,
                      ),
                      icon: const Icon(Icons.tune, size: 18),
                      label: const Text('Изменить rollout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _rolloutChip(String label, int? value) {
    return Chip(label: Text('$label: ${value ?? 0}%'));
  }
}

class _StatusMenu extends StatelessWidget {
  const _StatusMenu({required this.status, required this.onSelected});

  final String status;
  final ValueChanged<FeatureToggleStatus> onSelected;

  Color _colorFor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'active':
        return Colors.green;
      case 'disabled':
        return scheme.error;
      case 'archived':
        return scheme.outline;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FeatureToggleStatus>(
      onSelected: onSelected,
      itemBuilder: (context) => FeatureToggleStatus.values
          .map((s) => PopupMenuItem(value: s, child: Text(s.name)))
          .toList(),
      child: Chip(
        label: Text(status),
        backgroundColor: _colorFor(context, status).withValues(alpha: 0.12),
        labelStyle: TextStyle(color: _colorFor(context, status)),
        side: BorderSide.none,
      ),
    );
  }
}
