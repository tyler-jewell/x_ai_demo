import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  var _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  @protected
  void setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  @protected
  void setError(String? value) {
    if (_error == value) return;
    _error = value;
    notifyListeners();
  }

  @protected
  Future<T?> handleAsync<T>(Future<T> Function() action) async {
    if (_isLoading) return null;
    try {
      setLoading(true);
      final result = await action();
      setError(null);
      return result;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }
}
