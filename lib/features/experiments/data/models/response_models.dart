import '../../../../common/models/err_info_reason.dart';

class ExperimentReply {
  const ExperimentReply({required this.experimentName, required this.groupName});

  factory ExperimentReply.fromJson(Map<String, dynamic> json) {
    return ExperimentReply(
      experimentName: json['experiment_name'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
    );
  }

  final String experimentName;
  final String groupName;
}

class ExperimentsReply {
  const ExperimentsReply({
    required this.errInfoReason,
    required this.message,
    required this.experimentsReply,
  });

  factory ExperimentsReply.fromJson(Map<String, dynamic> json) {
    return ExperimentsReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      message: json['message'] as String? ?? '',
      experimentsReply: (json['experiments_reply'] as List<dynamic>? ?? [])
          .map((e) => ExperimentReply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final ErrInfoReason errInfoReason;
  final String message;
  final List<ExperimentReply> experimentsReply;
}

class GetGroup {
  const GetGroup({
    required this.id,
    required this.name,
    required this.rollingPercentage,
    required this.deviceId,
  });

  factory GetGroup.fromJson(Map<String, dynamic> json) {
    return GetGroup(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      rollingPercentage: json['rolling_percentage'] as int? ?? 0,
      deviceId: (json['device_id'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
    );
  }

  final int id;
  final String name;
  final int rollingPercentage;
  final List<int> deviceId;
}

class GetCustomParamWithCondition {
  const GetCustomParamWithCondition({
    required this.id,
    required this.parameterId,
    required this.parameterGroupId,
    required this.value,
    required this.condition,
  });

  factory GetCustomParamWithCondition.fromJson(Map<String, dynamic> json) {
    return GetCustomParamWithCondition(
      id: json['id'] as int,
      parameterId: json['parameter_id'] as int,
      parameterGroupId: json['parameter_group_id'] as int,
      value: json['value'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
    );
  }

  final int id;
  final int parameterId;
  final int parameterGroupId;
  final String value;
  final String condition;
}

class GetParamGroup {
  const GetParamGroup({
    required this.id,
    required this.percent,
    required this.paramsWithConditions,
  });

  factory GetParamGroup.fromJson(Map<String, dynamic> json) {
    return GetParamGroup(
      id: json['id'] as int,
      percent: json['percent'] as int? ?? 0,
      paramsWithConditions: (json['params_with_conditions'] as List<dynamic>? ?? [])
          .map((e) =>
              GetCustomParamWithCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int id;
  final int percent;
  final List<GetCustomParamWithCondition> paramsWithConditions;
}

class GetExperiment {
  const GetExperiment({
    required this.id,
    required this.name,
    required this.namespace,
    required this.status,
    required this.rolloutPercentage,
    required this.layersId,
    required this.paramsGroups,
    required this.groups,
    this.startDate,
    this.endDate,
    this.passingCities = const [],
    this.excludedCities = const [],
    this.passingStores = const [],
    this.excludedStores = const [],
  });

  factory GetExperiment.fromJson(Map<String, dynamic> json) {
    return GetExperiment(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      namespace: json['namespace'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rolloutPercentage: json['rollout_percentage'] as int? ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      passingCities: (json['passing_cities'] as List<dynamic>? ?? [])
          .cast<String>(),
      excludedCities: (json['excluded_cities'] as List<dynamic>? ?? [])
          .cast<String>(),
      passingStores: (json['passing_stores'] as List<dynamic>? ?? [])
          .cast<String>(),
      excludedStores: (json['excluded_stores'] as List<dynamic>? ?? [])
          .cast<String>(),
      layersId: (json['layers_id'] as List<dynamic>? ?? []).cast<int>(),
      paramsGroups: (json['params_groups'] as List<dynamic>? ?? [])
          .map((e) => GetParamGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => GetGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int id;
  final String name;
  final String namespace;
  final String status;
  final int rolloutPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> passingCities;
  final List<String> excludedCities;
  final List<String> passingStores;
  final List<String> excludedStores;
  final List<int> layersId;
  final List<GetParamGroup> paramsGroups;
  final List<GetGroup> groups;
}

class GetExperimentsResponse {
  const GetExperimentsResponse({required this.message, required this.experiments});

  factory GetExperimentsResponse.fromJson(Map<String, dynamic> json) {
    return GetExperimentsResponse(
      message: json['message'] as String? ?? '',
      experiments: (json['experiments'] as List<dynamic>? ?? [])
          .map((e) => GetExperiment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String message;
  final List<GetExperiment> experiments;
}

class GetExperimentByIDResponse {
  const GetExperimentByIDResponse({required this.message, required this.experiment});

  factory GetExperimentByIDResponse.fromJson(Map<String, dynamic> json) {
    return GetExperimentByIDResponse(
      message: json['message'] as String? ?? '',
      experiment: GetExperiment.fromJson(json['experiment'] as Map<String, dynamic>),
    );
  }

  final String message;
  final GetExperiment experiment;
}
