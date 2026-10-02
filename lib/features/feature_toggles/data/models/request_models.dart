import 'feature_toggle_status.dart';

class CreateFeatureToggleRequest {
  const CreateFeatureToggleRequest({
    required this.name,
    required this.namespaceId,
    this.iosRolloutPercentage,
    this.androidRolloutPercentage,
    this.webRolloutPercentage,
    this.rolloutPercentage,
  });

  final String name;
  final int namespaceId;
  final int? iosRolloutPercentage;
  final int? androidRolloutPercentage;
  final int? webRolloutPercentage;
  final int? rolloutPercentage;

  Map<String, dynamic> toJson() => {
        'name': name,
        'namespace_id': namespaceId,
        if (iosRolloutPercentage != null)
          'ios_rollout_percentage': iosRolloutPercentage,
        if (androidRolloutPercentage != null)
          'android_rollout_percentage': androidRolloutPercentage,
        if (webRolloutPercentage != null)
          'web_rollout_percentage': webRolloutPercentage,
        if (rolloutPercentage != null) 'rollout_percentage': rolloutPercentage,
      };
}

class UpdateFeatureToggleRolloutRequest {
  const UpdateFeatureToggleRolloutRequest({
    this.iosRolloutPercentage,
    this.androidRolloutPercentage,
    this.webRolloutPercentage,
    this.rolloutPercentage,
  });

  final int? iosRolloutPercentage;
  final int? androidRolloutPercentage;
  final int? webRolloutPercentage;
  final int? rolloutPercentage;

  Map<String, dynamic> toJson() => {
        if (iosRolloutPercentage != null)
          'ios_rollout_percentage': iosRolloutPercentage,
        if (androidRolloutPercentage != null)
          'android_rollout_percentage': androidRolloutPercentage,
        if (webRolloutPercentage != null)
          'web_rollout_percentage': webRolloutPercentage,
        if (rolloutPercentage != null) 'rollout_percentage': rolloutPercentage,
      };
}

class SetFeatureToggleStatusRequest {
  const SetFeatureToggleStatusRequest({required this.status});

  final FeatureToggleStatus status;

  Map<String, dynamic> toJson() => {'status': status.toJson()};
}

class IsUserInFeatureRequest {
  const IsUserInFeatureRequest({
    required this.userId,
    required this.namespace,
    required this.platform,
  });

  final int userId;
  final String namespace;
  final String platform;

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'namespace': namespace,
        'platform': platform,
      };
}
