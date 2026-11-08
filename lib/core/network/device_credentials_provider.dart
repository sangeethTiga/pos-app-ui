/// What the signing interceptor needs from the stored device session.
/// Implemented by the device_setup feature; kept here so core does not depend on features.
abstract interface class DeviceCredentialsProvider {
  /// `null` when the terminal is not paired.
  Future<({String accessToken, String signingSecret})?> deviceCredentials();
}
