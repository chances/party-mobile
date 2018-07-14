import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class SpotifyToken extends Object with _$SpotifyTokenSerializerMixin {
  SpotifyToken() {}
  factory SpotifyToken.fromJson(Map<String, dynamic> json) => _$SpotifyTokenFromJson(json);

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'token_expiry')
  String tokenExpiry;
}
