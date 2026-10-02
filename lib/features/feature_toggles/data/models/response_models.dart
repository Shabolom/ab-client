import '../../../../common/models/err_info_reason.dart';

class Feature {
  const Feature({required this.featureId, required this.featureName});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      featureId: json['feature_id'] as int,
      featureName: json['feature_name'] as String? ?? '',
    );
  }

  final int featureId;
  final String featureName;
}

class IsUserInFeatureReply {
  const IsUserInFeatureReply({
    required this.errInfoReason,
    required this.message,
    required this.features,
  });

  factory IsUserInFeatureReply.fromJson(Map<String, dynamic> json) {
    return IsUserInFeatureReply(
      errInfoReason: ErrInfoReason.fromJson(json['err_info_reason'] as String?),
      message: json['message'] as String? ?? '',
      features: (json['features'] as List<dynamic>? ?? [])
          .map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final ErrInfoReason errInfoReason;
  final String message;
  final List<Feature> features;

  bool get isOk => errInfoReason == ErrInfoReason.statusOk;
}

class GetFeatureToggle {
  const GetFeatureToggle({
    required this.id,
    required this.namespaceId,
    required this.name,
    required this.status,
    required this.createdAt,
    this.rolloutPercentage,
    this.ios,
    this.android,
    this.web,
    this.updatedAt,
    this.deletedAt,
  });

  factory GetFeatureToggle.fromJson(Map<String, dynamic> json) {
    return GetFeatureToggle(
      id: json['id'] as int,
      namespaceId: json['namespace_id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      rolloutPercentage: json['rollout_percentage'] as int?,
      ios: json['ios'] as int?,
      android: json['android'] as int?,
      web: json['web'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  final int id;
  final int namespaceId;
  final String name;
  final String status;
  final int? rolloutPercentage;
  final int? ios;
  final int? android;
  final int? web;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
}

class GetFeatureTogglesResponse {
  const GetFeatureTogglesResponse({required this.message, required this.featureToggles});

  factory GetFeatureTogglesResponse.fromJson(Map<String, dynamic> json) {
    return GetFeatureTogglesResponse(
      message: json['message'] as String? ?? '',
      featureToggles: (json['feature_toggles'] as List<dynamic>? ?? [])
          .map((e) => GetFeatureToggle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String message;
  final List<GetFeatureToggle> featureToggles;
}

class GetFeatureToggleByIDResponse {
  const GetFeatureToggleByIDResponse({required this.message, required this.featureToggle});

  factory GetFeatureToggleByIDResponse.fromJson(Map<String, dynamic> json) {
    return GetFeatureToggleByIDResponse(
      message: json['message'] as String? ?? '',
      featureToggle:
          GetFeatureToggle.fromJson(json['feature_toggle'] as Map<String, dynamic>),
    );
  }

  final String message;
  final GetFeatureToggle featureToggle;
}
