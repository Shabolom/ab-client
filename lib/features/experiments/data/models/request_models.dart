class Param {
  const Param({required this.paramName, required this.value});

  final String paramName;
  final String value;

  Map<String, dynamic> toJson() => {'param_name': paramName, 'value': value};
}

class ExperimentRequest {
  const ExperimentRequest({
    required this.splitId,
    required this.deviceId,
    required this.namespace,
    this.city,
    this.store,
    this.params = const [],
  });

  final int splitId;
  final int deviceId;
  final String namespace;
  final String? city;
  final String? store;
  final List<Param> params;

  Map<String, dynamic> toJson() => {
        'split_id': splitId,
        'device_id': deviceId,
        'namespace': namespace,
        if (city != null) 'city': city,
        if (store != null) 'store': store,
        if (params.isNotEmpty) 'params': params.map((p) => p.toJson()).toList(),
      };
}

class Group {
  const Group({
    this.id,
    required this.name,
    required this.rollingPercentage,
    this.deviceId = const [],
  });

  final int? id;
  final String name;
  final int rollingPercentage;
  final List<int> deviceId;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'rolling_percentage': rollingPercentage,
        if (deviceId.isNotEmpty) 'device_id': deviceId,
      };
}

/// Matches `CustomParamWithCondition`'s schema (`parameter_id`, `value`,
/// `condition`, required; `id`/`parameter_group_id` optional).
///
/// The openapi spec's own example for `CreateExperimentRequest.
/// custom_param_groups` uses a different shape (`parametr_id`, a nested
/// `custom_param` list) that doesn't match this schema or
/// `CustomParamGroup` — that example looks like a spec bug. This class
/// follows the formal schema, not the example; verify against a live
/// gateway response before relying on the exact field names.
class CustomParamWithCondition {
  const CustomParamWithCondition({
    this.id,
    required this.parameterId,
    this.parameterGroupId,
    required this.value,
    required this.condition,
  });

  final int? id;
  final int parameterId;
  final int? parameterGroupId;
  final String value;
  final String condition;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'parameter_id': parameterId,
        if (parameterGroupId != null) 'parameter_group_id': parameterGroupId,
        'value': value,
        'condition': condition,
      };
}

class CustomParamGroup {
  const CustomParamGroup({
    required this.percent,
    required this.paramsWithConditions,
  });

  final int percent;
  final List<CustomParamWithCondition> paramsWithConditions;

  Map<String, dynamic> toJson() => {
        'percent': percent,
        'params_with_conditions':
            paramsWithConditions.map((p) => p.toJson()).toList(),
      };
}

class CreateExperimentRequest {
  const CreateExperimentRequest({
    required this.name,
    required this.rolloutPercentage,
    required this.startDate,
    required this.endDate,
    required this.layersId,
    required this.groups,
    this.passingCities = const [],
    this.excludedCities = const [],
    this.passingStores = const [],
    this.excludedStores = const [],
    this.customParamGroups = const [],
  });

  final String name;
  final int rolloutPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> layersId;
  final List<Group> groups;
  final List<String> passingCities;
  final List<String> excludedCities;
  final List<String> passingStores;
  final List<String> excludedStores;
  final List<CustomParamGroup> customParamGroups;

  Map<String, dynamic> toJson() => {
        'name': name,
        'rollout_percentage': rolloutPercentage,
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
        'layers_id': layersId,
        'groups': groups.map((g) => g.toJson()).toList(),
        if (passingCities.isNotEmpty) 'passing_cities': passingCities,
        if (excludedCities.isNotEmpty) 'excluded_cities': excludedCities,
        if (passingStores.isNotEmpty) 'passing_stores': passingStores,
        if (excludedStores.isNotEmpty) 'excluded_stores': excludedStores,
        if (customParamGroups.isNotEmpty)
          'custom_param_groups':
              customParamGroups.map((g) => g.toJson()).toList(),
      };
}
