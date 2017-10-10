import 'Message.dart';

class SetAccessTokenStateMessage {
  Message _message;

  SetAccessTokenStateMessage(this._message);

  String get accessToken => _message.get("spotify.ACCESS_TOKEN");
  DateTime get expiresAt => DateTime.parse(_message.get("spotify.EXPIRES_AT"));

  static bool instanceOf(Message m) {
    return m.get("message.NAME") == "spotify.SET_TOKEN_STATE";
  }
}
