import 'message.dart';

class SetLoginStateMessage {
  Message _message;

  SetLoginStateMessage(this._message);

  bool get loggedIn => _message.get("spotify.IS_LOGGED_IN");

  static bool instanceOf(Message m) {
    return m.get("message.NAME") == "spotify.SET_LOGIN_STATE";
  }
}
