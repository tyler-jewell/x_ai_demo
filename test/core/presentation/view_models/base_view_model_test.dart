import 'package:flutter_app/core/presentation/view_models/base_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class TestViewModel extends BaseViewModel {
  Future<int?> successfulOperation() => handleAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 42;
      });

  Future<int?> failingOperation() => handleAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        throw Exception('Test error');
      });

  // Helper methods to expose protected methods for testing
  void setLoadingTest(bool value) => setLoading(value);
  void setErrorTest(String? value) => setError(value);
}

void main() {
  late TestViewModel viewModel;

  setUp(() {
    viewModel = TestViewModel();
  });

  group('BaseViewModel', () {
    test('initial state should be not loading and no error', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
    });

    group('setLoading', () {
      test('should update loading state and notify listeners', () {
        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.setLoadingTest(true);

        expect(viewModel.isLoading, true);
        expect(notified, true);
      });

      test('should not notify if same value is set', () {
        viewModel.setLoadingTest(false);

        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.setLoadingTest(false);

        expect(notified, false);
      });
    });

    group('setError', () {
      test('should update error state and notify listeners', () {
        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.setErrorTest('Test error');

        expect(viewModel.error, 'Test error');
        expect(notified, true);
      });

      test('should not notify if same error is set', () {
        viewModel.setErrorTest('Test error');

        var notified = false;
        viewModel.addListener(() => notified = true);

        viewModel.setErrorTest('Test error');

        expect(notified, false);
      });
    });

    group('handleAsync', () {
      test('should handle successful operation correctly', () async {
        final result = await viewModel.successfulOperation();

        expect(result, 42);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, null);
      });

      test('should handle failing operation correctly', () async {
        final result = await viewModel.failingOperation();

        expect(result, null);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, 'Exception: Test error');
      });

      test('should not execute if already loading', () async {
        // Start a long operation
        viewModel.successfulOperation();

        // Try to start another operation immediately
        final result = await viewModel.successfulOperation();

        expect(result, null);
      });

      test('should set loading state during operation', () async {
        var loadingDuringOperation = false;

        viewModel.addListener(() {
          if (viewModel.isLoading) {
            loadingDuringOperation = true;
          }
        });

        await viewModel.successfulOperation();

        expect(loadingDuringOperation, true);
        expect(viewModel.isLoading, false); // Should be false after completion
      });
    });
  });
}
