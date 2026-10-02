import 'package:flutter/material.dart';

import '../../../common/format.dart';
import '../../../common/widgets/form_dialog.dart';
import '../../../common/widgets/rollout_slider.dart';
import '../../custom_params/data/models/models.dart' show GetCustomParam;
import '../../layers/data/models/models.dart' show GetLayer;
import '../data/models/request_models.dart';
import 'experiments_controller.dart';

class _GroupDraft {
  _GroupDraft({this.name = ''});
  String name;
  int rollingPercentage = 50;
}

class _ConditionDraft {
  GetCustomParam? parameter;
  String condition = '=';
  String value = '';
}

class _ParamGroupDraft {
  _ParamGroupDraft() : conditions = [_ConditionDraft()];
  int percent = 50;
  List<_ConditionDraft> conditions;
}

Future<bool?> showCreateExperimentDialog(
  BuildContext context, {
  required ExperimentsController controller,
  required List<GetLayer> layers,
  required List<GetCustomParam> customParams,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passingCitiesController = TextEditingController();
  final excludedCitiesController = TextEditingController();
  final passingStoresController = TextEditingController();
  final excludedStoresController = TextEditingController();

  double rollout = 50;
  DateTime? startDate;
  DateTime? endDate;
  final selectedLayerIds = <int>{};
  final groups = <_GroupDraft>[_GroupDraft(name: 'control'), _GroupDraft(name: 'test')];
  final paramGroups = <_ParamGroupDraft>[];

  List<String> splitCsv(String raw) =>
      raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => FormDialog(
        title: 'Новый эксперимент',
        formKey: formKey,
        submitLabel: 'Создать',
        width: 560,
        onSubmit: () async {
          if (selectedLayerIds.isEmpty) {
            return 'Выберите хотя бы один слой';
          }
          if (groups.isEmpty || groups.any((g) => g.name.trim().isEmpty)) {
            return 'Добавьте хотя бы одну группу с названием';
          }
          if (startDate == null || endDate == null) {
            return 'Укажите даты начала и окончания';
          }
          if (!endDate!.isAfter(startDate!)) {
            return 'Дата окончания должна быть позже даты начала';
          }
          final incompleteParamGroup = paramGroups.any(
            (g) => g.conditions.any((c) => c.parameter == null || c.value.trim().isEmpty),
          );
          if (incompleteParamGroup) {
            return 'Заполните параметр и значение во всех условиях таргетинга';
          }
          return controller.create(
            CreateExperimentRequest(
              name: nameController.text.trim(),
              rolloutPercentage: rollout.round(),
              startDate: startDate!,
              endDate: endDate!,
              layersId: selectedLayerIds.toList(),
              groups: groups
                  .map((g) => Group(name: g.name.trim(), rollingPercentage: g.rollingPercentage))
                  .toList(),
              passingCities: splitCsv(passingCitiesController.text),
              excludedCities: splitCsv(excludedCitiesController.text),
              passingStores: splitCsv(passingStoresController.text),
              excludedStores: splitCsv(excludedStoresController.text),
              customParamGroups: paramGroups
                  .map((g) => CustomParamGroup(
                        percent: g.percent,
                        paramsWithConditions: g.conditions
                            .map((c) => CustomParamWithCondition(
                                  parameterId: c.parameter!.id,
                                  condition: c.condition.trim().isEmpty ? '=' : c.condition.trim(),
                                  value: c.value.trim(),
                                ))
                            .toList(),
                      ))
                  .toList(),
            ),
          );
        },
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название эксперимента'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Укажите название' : null,
            ),
            const SizedBox(height: 8),
            RolloutSlider(
              label: 'Rollout',
              value: rollout,
              onChanged: (v) => setState(() => rollout = v),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _DatePickerField(
                    label: 'Начало',
                    date: startDate,
                    onPick: (d) => setState(() => startDate = d),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePickerField(
                    label: 'Окончание',
                    date: endDate,
                    onPick: (d) => setState(() => endDate = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerLeft, child: Text('Слои', style: Theme.of(context).textTheme.labelLarge)),
            const SizedBox(height: 8),
            if (layers.isEmpty)
              const Text('Сначала создайте хотя бы один слой')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: layers.map((layer) {
                  final selected = selectedLayerIds.contains(layer.id);
                  return FilterChip(
                    label: Text(layer.name),
                    selected: selected,
                    onSelected: (value) => setState(() {
                      if (value) {
                        selectedLayerIds.add(layer.id);
                      } else {
                        selectedLayerIds.remove(layer.id);
                      }
                    }),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child:
                        Text('Группы', style: Theme.of(context).textTheme.labelLarge)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Добавить группу',
                  onPressed: () => setState(() => groups.add(_GroupDraft())),
                ),
              ],
            ),
            ...groups.map((group) => _GroupRow(
                  key: ValueKey(group),
                  group: group,
                  onChanged: () => setState(() {}),
                  onRemove: groups.length <= 1
                      ? null
                      : () => setState(() => groups.remove(group)),
                )),
            const SizedBox(height: 16),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Города и точки продаж (необязательно)'),
              children: [
                TextFormField(
                  controller: passingCitiesController,
                  decoration: const InputDecoration(labelText: 'Города, через запятую'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: excludedCitiesController,
                  decoration: const InputDecoration(labelText: 'Исключённые города, через запятую'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passingStoresController,
                  decoration: const InputDecoration(labelText: 'Точки продаж, через запятую'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: excludedStoresController,
                  decoration: const InputDecoration(labelText: 'Исключённые точки, через запятую'),
                ),
              ],
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Таргетинг по кастомным параметрам (необязательно)'),
              children: [
                if (customParams.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Кастомных параметров пока нет'),
                  ),
                ...paramGroups.map((group) => _ParamGroupCard(
                      key: ValueKey(group),
                      group: group,
                      customParams: customParams,
                      onChanged: () => setState(() {}),
                      onRemove: () => setState(() => paramGroups.remove(group)),
                    )),
                if (customParams.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() => paramGroups.add(_ParamGroupDraft())),
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить группу условий'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.label, required this.date, required this.onPick});

  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 3),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(formatDateOrNull(date) ?? 'Выбрать дату'),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    super.key,
    required this.group,
    required this.onChanged,
    required this.onRemove,
  });

  final _GroupDraft group;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: group.name,
              decoration: const InputDecoration(labelText: 'Группа'),
              onChanged: (v) {
                group.name = v;
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: RolloutSlider(
              label: '%',
              value: group.rollingPercentage.toDouble(),
              onChanged: (v) {
                group.rollingPercentage = v.round();
                onChanged();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _ParamGroupCard extends StatelessWidget {
  const _ParamGroupCard({
    super.key,
    required this.group,
    required this.customParams,
    required this.onChanged,
    required this.onRemove,
  });

  final _ParamGroupDraft group;
  final List<GetCustomParam> customParams;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: RolloutSlider(
                    label: 'Доля группы',
                    value: group.percent.toDouble(),
                    onChanged: (v) {
                      group.percent = v.round();
                      onChanged();
                    },
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: onRemove),
              ],
            ),
            ...group.conditions.map((condition) => _ConditionRow(
                  key: ValueKey(condition),
                  condition: condition,
                  customParams: customParams,
                  onChanged: onChanged,
                  onRemove: group.conditions.length <= 1
                      ? null
                      : () {
                          group.conditions.remove(condition);
                          onChanged();
                        },
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  group.conditions.add(_ConditionDraft());
                  onChanged();
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Условие'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({
    super.key,
    required this.condition,
    required this.customParams,
    required this.onChanged,
    required this.onRemove,
  });

  final _ConditionDraft condition;
  final List<GetCustomParam> customParams;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<GetCustomParam>(
              initialValue: condition.parameter,
              decoration: const InputDecoration(labelText: 'Параметр'),
              items: customParams
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                  .toList(),
              onChanged: (v) {
                condition.parameter = v;
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: condition.condition,
              decoration: const InputDecoration(labelText: 'Усл.'),
              onChanged: (v) {
                condition.condition = v;
                onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: condition.value,
              decoration: const InputDecoration(labelText: 'Значение'),
              onChanged: (v) {
                condition.value = v;
                onChanged();
              },
            ),
          ),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: onRemove),
        ],
      ),
    );
  }
}
