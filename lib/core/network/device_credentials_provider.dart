/// What the signing interceptor needs from the stored device session.
/// Implemented by the device_setup feature; kept here so core does not depend on features.
abstract interface class DeviceCredentialsProvider {
  /// `null` when the terminal is not paired.
  Future<({String accessToken, String signingSecret})?> deviceCredentials();

  /// True when the access token expires within a minute (refresh before sending).
  Future<bool> accessTokenExpiring();

  /// `POST /devices/token/refresh` with the stored refresh token; stores the new tokens.
  /// Returns false when the refresh token is invalid (pairing needed again).
  Future<bool> refreshTokens();
}
