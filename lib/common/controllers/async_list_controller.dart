import 'package:flutter/foundation.dart';

import '../../core/network/api_exception.dart';

enum LoadStatus { initial, loading, loaded, error }

/// Owns the load/loading/error/empty state for one list endpoint, so every
/// feature's list screen renders the same four states the same way instead
/// of each reimplementing its own spinner/error/empty branching.
class AsyncListController<T> extends ChangeNotifier {
  AsyncListController(this._fetch);

  final Future<List<T>> Function() _fetch;

  LoadStatus status = LoadStatus.initial;
  List<T> items = const [];
  String? errorMessage;

  /// True once a load has been kicked off, so callers can avoid firing a
  /// second concurrent fetch (e.g. both "load on tab open" and a manual
  /// pull-to-refresh landing at once).
  bool _isLoading = false;

  /// Screens get disposed (e.g. on logout) while a request from them is
  /// still in flight; without this, that request's completion would call
  /// notifyListeners() on an already-disposed ChangeNotifier and crash.
  bool _isDisposed = false;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _fetch();
      if (_isDisposed) return;
      items = result;
      status = LoadStatus.loaded;
    } on ApiException catch (e) {
      if (_isDisposed) return;
      status = LoadStatus.error;
      errorMessage = e.message;
    } finally {
      _isLoading = false;
    }
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
