import '../../common/models/err_info_reason.dart';
import '../../features/custom_params/data/models/models.dart' show GetCustomParam;
import '../../features/experiments/data/models/response_models.dart';
import '../../features/feature_toggles/data/models/feature_toggle_status.dart';
import '../../features/feature_toggles/data/models/response_models.dart'
    show GetFeatureToggle, Feature, IsUserInFeatureReply;
import '../../features/layers/data/models/models.dart' show GetLayer;
import '../../features/namespaces/data/models/models.dart' show GetNamespace;
import '../../features/users/data/models/user.dart';

/// Simple network-latency simulation shared by every `Mock*Api`.
Future<void> mockLatency() => Future<void>.delayed(const Duration(milliseconds: 320));

class _MutableUser {
  _MutableUser({
    required this.id,
    required this.mail,
    required this.password,
    required this.name,
    required this.age,
    required this.createdAt,
    required this.addedAt,
  });

  final String id;
  String mail;
  String password;
  String name;
  int age;
  final DateTime createdAt;
  final DateTime addedAt;

  User toUser() =>
      User(id: id, mail: mail, name: name, age: age, createdAt: createdAt, addedAt: addedAt);
}

class MockBackend {
  MockBackend() {
    _seed();
  }

  // -- auth/session state ---------------------------------------------
  bool isAuthenticated = false;
  String? currentUserId;

  final List<_MutableUser> _users = [];

  // -- domain state ------------------------------------------------------
  final List<GetNamespace> namespaces = [];
  final List<GetLayer> layers = [];
  final List<GetCustomParam> customParams = [];
  final List<GetFeatureToggle> featureToggles = [];
  final List<GetExperiment> experiments = [];

  int _namespaceSeq = 100;
  int _layerSeq = 100;
  int _customParamSeq = 100;
  int _featureToggleSeq = 100;
  int _experimentSeq = 100;
  int _userSeq = 100;

  static const demoMail = 'admin@example.com';
  static const demoPassword = 'demo1234';

  void _seed() {
    final now = DateTime.now();

    namespaces.addAll([
      const GetNamespace(id: 1, name: 'checkout', description: 'Оформление заказа'),
      const GetNamespace(id: 2, name: 'search', description: 'Поиск и выдача'),
    ]);

    layers.addAll([
      const GetLayer(
          id: 1, namespaceId: 1, name: 'checkout-layer', description: 'Основной слой чекаута'),
      const GetLayer(
          id: 2, namespaceId: 2, name: 'search-ranking', description: 'Ранжирование поиска'),
    ]);

    customParams.addAll([
      const GetCustomParam(id: 1, namespaceId: 1, name: 'device_type', type: 'string'),
      const GetCustomParam(id: 2, namespaceId: 2, name: 'is_premium', type: 'bool'),
    ]);

    featureToggles.addAll([
      GetFeatureToggle(
        id: 1,
        namespaceId: 1,
        name: 'new_checkout_button',
        status: FeatureToggleStatus.active.name,
        rolloutPercentage: 50,
        ios: 40,
        android: 60,
        web: 50,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      GetFeatureToggle(
        id: 2,
        namespaceId: 2,
        name: 'search_v2_ranking',
        status: FeatureToggleStatus.draft.name,
        rolloutPercentage: 0,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      GetFeatureToggle(
        id: 3,
        namespaceId: 1,
        name: 'express_delivery_badge',
        status: FeatureToggleStatus.disabled.name,
        rolloutPercentage: 10,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
    ]);

    experiments.addAll([
      GetExperiment(
        id: 1,
        name: 'Checkout button color',
        namespace: 'checkout',
        status: 'ready',
        rolloutPercentage: 100,
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 25)),
        layersId: const [1],
        paramsGroups: const [],
        groups: const [
          GetGroup(id: 1, name: 'control', rollingPercentage: 50, deviceId: []),
          GetGroup(id: 2, name: 'variant', rollingPercentage: 50, deviceId: []),
        ],
      ),
      GetExperiment(
        id: 2,
        name: 'Search ranking v2',
        namespace: 'search',
        status: 'draft',
        rolloutPercentage: 20,
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        layersId: const [2],
        paramsGroups: const [],
        groups: const [
          GetGroup(id: 3, name: 'control', rollingPercentage: 80, deviceId: []),
          GetGroup(id: 4, name: 'variant', rollingPercentage: 20, deviceId: []),
        ],
      ),
    ]);

    _users.add(_MutableUser(
      id: 'demo-user-1',
      mail: demoMail,
      password: demoPassword,
      name: 'Demo Admin',
      age: 30,
      createdAt: now.subtract(const Duration(days: 30)),
      addedAt: now.subtract(const Duration(days: 30)),
    ));
  }

  // -- auth ---------------------------------------------------------------

  /// Returns the matching user on success, null on bad credentials.
  User? login(String mail, String password) {
    final match = _users.where(
      (u) => u.mail.toLowerCase() == mail.toLowerCase() && u.password == password,
    );
    if (match.isEmpty) return null;
    final user = match.first;
    isAuthenticated = true;
    currentUserId = user.id;
    return user.toUser();
  }

  User register({
    required String mail,
    required String password,
    required String name,
    required int age,
  }) {
    final now = DateTime.now();
    final user = _MutableUser(
      id: 'mock-user-${_userSeq++}',
      mail: mail,
      password: password,
      name: name,
      age: age,
      createdAt: now,
      addedAt: now,
    );
    _users.add(user);
    isAuthenticated = true;
    currentUserId = user.id;
    return user.toUser();
  }

  void logout() {
    isAuthenticated = false;
    currentUserId = null;
  }

  _MutableUser? get _currentUser =>
      currentUserId == null ? null : _users.where((u) => u.id == currentUserId).firstOrNull;

  User? get currentUser => _currentUser?.toUser();

  List<User> get allUsers => _users.map((u) => u.toUser()).toList();

  User updateCurrentUser({String? mail, String? name, int? age}) {
    final user = _currentUser;
    if (user == null) {
      throw StateError('No authenticated mock user');
    }
    if (mail != null) user.mail = mail;
    if (name != null) user.name = name;
    if (age != null) user.age = age;
    return user.toUser();
  }

  User deleteCurrentUser() {
    final user = _currentUser;
    if (user == null) {
      throw StateError('No authenticated mock user');
    }
    _users.removeWhere((u) => u.id == user.id);
    logout();
    return user.toUser();
  }

  // -- namespaces -----------------------------------------------------------

  GetNamespace createNamespace({required String name, String? description}) {
    final ns = GetNamespace(id: ++_namespaceSeq, name: name, description: description ?? '');
    namespaces.add(ns);
    return ns;
  }

  // -- layers -----------------------------------------------------------

  GetLayer createLayer({required int namespaceId, required String name, String? description}) {
    final layer = GetLayer(
      id: ++_layerSeq,
      namespaceId: namespaceId,
      name: name,
      description: description ?? '',
    );
    layers.add(layer);
    return layer;
  }

  // -- custom params -----------------------------------------------------------

  GetCustomParam createCustomParam({
    required String name,
    required int namespaceId,
    required String type,
  }) {
    final param =
        GetCustomParam(id: ++_customParamSeq, namespaceId: namespaceId, name: name, type: type);
    customParams.add(param);
    return param;
  }

  // -- feature toggles -----------------------------------------------------------

  GetFeatureToggle createFeatureToggle({
    required String name,
    required int namespaceId,
    int? iosRolloutPercentage,
    int? androidRolloutPercentage,
    int? webRolloutPercentage,
    int? rolloutPercentage,
  }) {
    final toggle = GetFeatureToggle(
      id: ++_featureToggleSeq,
      namespaceId: namespaceId,
      name: name,
      status: FeatureToggleStatus.draft.name,
      rolloutPercentage: rolloutPercentage,
      ios: iosRolloutPercentage,
      android: androidRolloutPercentage,
      web: webRolloutPercentage,
      createdAt: DateTime.now(),
    );
    featureToggles.add(toggle);
    return toggle;
  }

  GetFeatureToggle? _findFeatureToggle(int id) =>
      featureToggles.where((f) => f.id == id).firstOrNull;

  GetFeatureToggle? updateFeatureToggleRollout(
    int id, {
    int? iosRolloutPercentage,
    int? androidRolloutPercentage,
    int? webRolloutPercentage,
    int? rolloutPercentage,
  }) {
    final existing = _findFeatureToggle(id);
    if (existing == null) return null;
    final updated = GetFeatureToggle(
      id: existing.id,
      namespaceId: existing.namespaceId,
      name: existing.name,
      status: existing.status,
      rolloutPercentage: rolloutPercentage ?? existing.rolloutPercentage,
      ios: iosRolloutPercentage ?? existing.ios,
      android: androidRolloutPercentage ?? existing.android,
      web: webRolloutPercentage ?? existing.web,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existing.deletedAt,
    );
    featureToggles[featureToggles.indexOf(existing)] = updated;
    return updated;
  }

  GetFeatureToggle? setFeatureToggleStatus(int id, FeatureToggleStatus status) {
    final existing = _findFeatureToggle(id);
    if (existing == null) return null;
    final updated = GetFeatureToggle(
      id: existing.id,
      namespaceId: existing.namespaceId,
      name: existing.name,
      status: status.name,
      rolloutPercentage: existing.rolloutPercentage,
      ios: existing.ios,
      android: existing.android,
      web: existing.web,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existing.deletedAt,
    );
    featureToggles[featureToggles.indexOf(existing)] = updated;
    return updated;
  }

  int _bucketFor(Object seed) => seed.hashCode.abs() % 100;

  bool isFeatureEnabledFor(int featureToggleId) {
    final toggle = _findFeatureToggle(featureToggleId);
    if (toggle == null) return false;
    if (toggle.status != FeatureToggleStatus.active.name) return false;
    final pct = toggle.rolloutPercentage ?? 0;
    return pct >= 100;
  }

  IsUserInFeatureReply isUserInFeature({
    required int userId,
    required String namespace,
    required String platform,
  }) {
    final ns = namespaces.where((n) => n.name == namespace).firstOrNull;
    final matches = featureToggles.where((f) {
      if (ns != null && f.namespaceId != ns.id) return false;
      if (f.status != FeatureToggleStatus.active.name) return false;
      final platformPct = switch (platform.toLowerCase()) {
        'ios' => f.ios,
        'android' => f.android,
        'web' => f.web,
        _ => null,
      };
      final pct = platformPct ?? f.rolloutPercentage ?? 0;
      return _bucketFor('$userId-${f.id}') < pct;
    });
    return IsUserInFeatureReply(
      errInfoReason: ErrInfoReason.statusOk,
      message: matches.isEmpty ? 'Пользователь не попал ни в одну фичу' : 'OK',
      features: matches.map((f) => Feature(featureId: f.id, featureName: f.name)).toList(),
    );
  }

  // -- experiments -----------------------------------------------------------

  GetExperiment createExperiment({
    required String name,
    required int rolloutPercentage,
    required DateTime startDate,
    required DateTime endDate,
    required List<int> layersId,
    required List<GetGroup> groups,
    List<String> passingCities = const [],
    List<String> excludedCities = const [],
    List<String> passingStores = const [],
    List<String> excludedStores = const [],
  }) {
    final namespaceId = layersId.isEmpty
        ? null
        : layers.where((l) => l.id == layersId.first).firstOrNull?.namespaceId;
    final namespaceName =
        namespaceId == null ? '' : (namespaces.where((n) => n.id == namespaceId).firstOrNull?.name ?? '');
    final experiment = GetExperiment(
      id: ++_experimentSeq,
      name: name,
      namespace: namespaceName,
      status: 'draft',
      rolloutPercentage: rolloutPercentage,
      startDate: startDate,
      endDate: endDate,
      layersId: layersId,
      paramsGroups: const [],
      groups: groups,
      passingCities: passingCities,
      excludedCities: excludedCities,
      passingStores: passingStores,
      excludedStores: excludedStores,
    );
    experiments.add(experiment);
    return experiment;
  }

  GetExperiment? _findExperiment(int id) => experiments.where((e) => e.id == id).firstOrNull;

  GetExperiment? _setExperimentStatus(int id, String status) {
    final existing = _findExperiment(id);
    if (existing == null) return null;
    final updated = GetExperiment(
      id: existing.id,
      name: existing.name,
      namespace: existing.namespace,
      status: status,
      rolloutPercentage: existing.rolloutPercentage,
      startDate: existing.startDate,
      endDate: existing.endDate,
      passingCities: existing.passingCities,
      excludedCities: existing.excludedCities,
      passingStores: existing.passingStores,
      excludedStores: existing.excludedStores,
      layersId: existing.layersId,
      paramsGroups: existing.paramsGroups,
      groups: existing.groups,
    );
    experiments[experiments.indexOf(existing)] = updated;
    return updated;
  }

  GetExperiment? setReadyExperiment(int id) => _setExperimentStatus(id, 'ready');

  GetExperiment? setStoppedExperiment(int id) => _setExperimentStatus(id, 'stopped');

  List<ExperimentReply> resolveUserExperiment({
    required int deviceId,
    required String namespace,
  }) {
    final active = experiments.where((e) => e.namespace == namespace && e.status == 'ready');
    final result = <ExperimentReply>[];
    for (final experiment in active) {
      if (experiment.groups.isEmpty) continue;
      final bucket = _bucketFor('$deviceId-${experiment.id}');
      var cursor = 0;
      for (final group in experiment.groups) {
        cursor += group.rollingPercentage;
        if (bucket < cursor) {
          result.add(ExperimentReply(experimentName: experiment.name, groupName: group.name));
          break;
        }
      }
    }
    return result;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
