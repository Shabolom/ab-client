import 'package:flutter/material.dart';

import '../../../common/format.dart';
import '../../../common/widgets/app_snack.dart';
import '../data/models/response_models.dart';
import 'experiments_controller.dart';

void showExperimentDetail(
  BuildContext context, {
  required ExperimentsController controller,
  required GetExperiment experiment,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, scrollController) => _ExperimentDetail(
        controller: controller,
        experiment: experiment,
        scrollController: scrollController,
      ),
    ),
  );
}

class _ExperimentDetail extends StatefulWidget {
  const _ExperimentDetail({
    required this.controller,
    required this.experiment,
    required this.scrollController,
  });

  final ExperimentsController controller;
  final GetExperiment experiment;
  final ScrollController scrollController;

  @override
  State<_ExperimentDetail> createState() => _ExperimentDetailState();
}

class _ExperimentDetailState extends State<_ExperimentDetail> {
  bool _isBusy = false;

  Future<void> _transition(Future<String?> Function() action) async {
    setState(() => _isBusy = true);
    final error = await action();
    if (!mounted) return;
    setState(() => _isBusy = false);
    if (error != null) {
      AppSnack.error(context, error);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final experiment = widget.experiment;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(experiment.name, style: Theme.of(context).textTheme.headlineSmall),
              ),
              Chip(label: Text(experiment.status)),
            ],
          ),
          Text('Namespace: ${experiment.namespace}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          _row('Rollout', '${experiment.rolloutPercentage}%'),
          _row('Начало', formatDateOrNull(experiment.startDate) ?? '—'),
          _row('Окончание', formatDateOrNull(experiment.endDate) ?? '—'),
          _row('Слои', experiment.layersId.map((id) => '#$id').join(', ')),
          if (experiment.passingCities.isNotEmpty)
            _row('Города', experiment.passingCities.join(', ')),
          if (experiment.excludedCities.isNotEmpty)
            _row('Искл. города', experiment.excludedCities.join(', ')),
          if (experiment.passingStores.isNotEmpty)
            _row('Точки', experiment.passingStores.join(', ')),
          if (experiment.excludedStores.isNotEmpty)
            _row('Искл. точки', experiment.excludedStores.join(', ')),
          const SizedBox(height: 16),
          Text('Группы', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          ...experiment.groups.map(
            (group) => Card(
              child: ListTile(
                title: Text(group.name),
                subtitle: Text('${group.rollingPercentage}% · устройств: ${group.deviceId.length}'),
              ),
            ),
          ),
          if (experiment.paramsGroups.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Таргетинг по параметрам', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            ...experiment.paramsGroups.map(
              (group) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${group.percent}% группы'),
                      ...group.paramsWithConditions.map(
                        (c) => Text('  параметр #${c.parameterId} ${c.condition} ${c.value}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isBusy
                      ? null
                      : () => _transition(() => widget.controller.setReady(experiment.id)),
                  child: const Text('Сделать активным'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _isBusy
                      ? null
                      : () => _transition(() => widget.controller.setStopped(experiment.id)),
                  child: const Text('Остановить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
