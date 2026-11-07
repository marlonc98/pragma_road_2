import 'package:portal_remoto/domain/constants/errors_constants.dart';

enum AsyncStatus { notStarted, loading, complete, failed }

class AsyncState<T> {
  AsyncStatus status;
  T? data;
  String? error;

  AsyncState({
    this.status = AsyncStatus.loading,
    this.data,
    this.error,
  });

  AsyncState.notStarted() : status = AsyncStatus.notStarted;

  factory AsyncState.success({T? data}) {
    return AsyncState(status: AsyncStatus.complete, data: data);
  }

  factory AsyncState.loading() {
    return AsyncState(status: AsyncStatus.loading);
  }

  factory AsyncState.fromError(
    dynamic error, {
    String? defaultError,
  }) {
    String? errorGetted;
    if (error.toString().contains("Operation timed out") ||
        error.toString().contains("SocketException") ||
        error.toString().contains(ErrorsConstants.noInternet)) {
      errorGetted = ErrorsConstants.noInternet;
    } else if (error.toString().contains(ErrorsConstants.timeout)) {
      errorGetted = ErrorsConstants.timeout;
    } else if (error is String) {
      errorGetted = error;
      if (!ErrorsConstants.existsKey(error)) {
        errorGetted = defaultError ?? error;
      }
    } else if (error is Exception) {
      if (error.toString() == Exception().toString()) {
        errorGetted = defaultError ?? ErrorsConstants.unknownError;
      } else {
        errorGetted = error.toString();
      }
    }
    return AsyncState(
      status: AsyncStatus.failed,
      error: errorGetted,
    );
  }

  bool get isSuccess => status == AsyncStatus.complete;
  bool get isError => status == AsyncStatus.failed;
  bool get isLoading => status == AsyncStatus.loading;
  bool get isNotStarted => status == AsyncStatus.notStarted;

  AsyncState changeStatus(AsyncStatus status) {
    return AsyncState(status: status, data: data, error: error);
  }

  AsyncState setLoading() {
    return changeStatus(AsyncStatus.loading);
  }

  @override
  String toString() {
    return 'AsyncState{status: $status, data: $data, error: $error}';
  }

  AsyncState<T> copyWith({
    AsyncStatus? status,
    T? data,
    String? error,
  }) {
    return AsyncState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  AsyncState<R> map<R>(R Function(T) transform) {
    if (isError) {
      return AsyncState<R>(status: status, error: error);
    }
    return AsyncState<R>(
      status: status,
      data: data != null ? transform(data as T) : null,
      error: error,
    );
  }
}
