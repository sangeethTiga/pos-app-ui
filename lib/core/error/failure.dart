import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Everything that can go wrong below the presentation layer.
@freezed
sealed class Failure with _$Failure {
  /// No connection, timeout, DNS: safe to retry the same request.
  const factory Failure.network({required String message}) = NetworkFailure;

  /// The backend answered with its error envelope
  /// `{"error": {"code", "message", "details", "retryable"}}`.
  const factory Failure.server({
    required int statusCode,
    required String code,
    required String message,
    @Default(false) bool retryable,
    @Default(<String, dynamic>{}) Map<String, dynamic> details,
  }) = ServerFailure;

  /// The terminal has no credentials, or the server revoked them.
  const factory Failure.unauthorized({required String code, required String message}) = UnauthorizedFailure;

  const factory Failure.unexpected({required String message}) = UnexpectedFailure;
}

extension FailureMessage on Failure {
  /// Text that can be shown to the cashier as is.
  String get userMessage => switch (this) {
    NetworkFailure() => 'Cannot reach the server. Check the network and try again.',
    ServerFailure(:final message) => message,
    UnauthorizedFailure(:final message) => message,
    UnexpectedFailure(:final message) => message,
  };
}
