import 'package:flutter/material.dart';

import '../../../common/format.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/async_list_view.dart';
import '../../../common/widgets/feature_scaffold.dart';
import '../../custom_params/presentation/custom_params_controller.dart';
import '../../layers/presentation/layers_controller.dart';
import '../data/models/response_models.dart';
import 'experiment_detail_sheet.dart';
import 'experiment_form_dialog.dart';
import 'experiments_controller.dart';

class ExperimentsScreen extends StatelessWidget {
  const ExperimentsScreen({
    super.key,
    required this.controller,
    required this.layers,
    required this.customParams,
  });

  final ExperimentsController controller;
  final LayersController layers;
  final CustomParamsController customParams;

  Color _statusColor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case 'active':
        return Colors.green;
      case 'ready':
        return scheme.primary;
      case 'stopped':
        return scheme.outline;
      default:
        return scheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Эксперименты',
      subtitle: 'Создание и управление A/B-экспериментами',
      onAdd: () {
        if (layers.list.items.isEmpty) {
          AppSnack.error(context, 'Сначала создайте хотя бы один слой');
          return;
        }
        showCreateExperimentDialog(
          context,
          controller: controller,
          layers: layers.list.items,
          customParams: customParams.list.items,
        );
      },
      child: AsyncListView<GetExperiment>(
        controller: controller.list,
        emptyLabel: 'Экспериментов пока нет',
        itemBuilder: (context, experiment) => Card(
          child: ListTile(
            onTap: () => showExperimentDetail(
              context,
              controller: controller,
              experiment: experiment,
            ),
            title: Text(experiment.name),
            subtitle: Text(
              '${experiment.namespace} · rollout ${experiment.rolloutPercentage}%'
              '${experiment.endDate != null ? ' · до ${formatDate(experiment.endDate!)}' : ''}',
            ),
            trailing: Chip(
              label: Text(experiment.status),
              backgroundColor: _statusColor(context, experiment.status).withValues(alpha: 0.12),
              labelStyle: TextStyle(color: _statusColor(context, experiment.status)),
              side: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
