import '../error/failure.dart';

/// Return type of repositories: either a value or a [Failure], never a thrown exception.
sealed class Result<T> {
  const Result();

  R when<R>({required R Function(T value) success, required R Function(Failure failure) failure}) => switch (this) {
    Success<T>(:final value) => success(value),
    Err<T>(failure: final f) => failure(f),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
