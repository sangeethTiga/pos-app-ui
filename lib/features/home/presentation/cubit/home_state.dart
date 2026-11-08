part of 'home_cubit.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;

  /// [status] is null while the server check runs or when it failed ([failure]).
  const factory HomeState.ready({
    required DeviceSession session,
    DeviceStatus? status,
    Failure? failure,
    @Default(false) bool checking,
  }) = HomeReady;

  const factory HomeState.unpaired() = HomeUnpaired;
}
