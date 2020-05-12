import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class SpotifyToken extends Object {
  SpotifyToken();
  static SpotifyToken fromJson(Map<String, dynamic> json) =>
      _$SpotifyTokenFromJson(json);

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  @JsonKey(name: 'token_expiry')
  String tokenExpiry;
}
