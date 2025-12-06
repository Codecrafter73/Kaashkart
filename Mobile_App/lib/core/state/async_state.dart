// lib/core/state/async_state.dart
class AsyncState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const AsyncState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  // Helpers
  bool get hasData => data != null && error == null;
  bool get hasError => error != null;

  AsyncState<T> loading() => AsyncState<T>(isLoading: true, data: data, error: null);
  AsyncState<T> success(T data) => AsyncState<T>(isLoading: false, data: data);
  AsyncState<T> failure(String error) => AsyncState<T>(isLoading: false, error: error);

  // AsyncState<T> copyWith({
  //   bool? isLoading,
  //   T? data,
  //   String? error,
  // }) {
  //   return AsyncState<T>(
  //     isLoading: isLoading ?? this.isLoading,
  //     data: data ?? this.data,
  //     error: error,
  //   );
  // }
}