import 'dart:typed_data';
import 'package:flutter/services.dart';

class Message {
  var map = new Map<String, dynamic>();

  Message();
  Message.fromMap(Map<String, dynamic> map) {
    this.map = map;
  }

  get(String field) => map[field];

  static final MessageCodec<Message> codec = new Codec();

  static final String setLoginState = "spotify.SET_LOGIN_STATE";
  static final String setTokenState = "spotify.SET_TOKEN_STATE";
}

class Codec implements MessageCodec<Message> {
  var stdCodec = new StandardMessageCodec();

  @override
  ByteData encodeMessage(Message message) {
    if (message == null) return null;
    return stdCodec.encodeMessage(message.map);
  }

  @override
  Message decodeMessage(ByteData message) {
    return new Message.fromMap(stdCodec.decodeMessage(message));
  }
}
