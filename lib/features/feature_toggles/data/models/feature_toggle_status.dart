enum FeatureToggleStatus {
  draft,
  active,
  disabled,
  archived;

  static FeatureToggleStatus fromJson(String? value) {
    return FeatureToggleStatus.values.firstWhere(
      (v) => v.name == value,
      orElse: () => FeatureToggleStatus.draft,
    );
  }

  String toJson() => name;
}
