import 'package:owl/annotation/json.dart';

@JsonClass()
class SpotifyToken {
  @JsonField(key: 'access_token')
  String accessToken;

  @JsonField(key: 'token_expiry')
  String tokenExpiry;
}
