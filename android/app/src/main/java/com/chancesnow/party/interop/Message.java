package com.chancesnow.party.interop;

import java.nio.ByteBuffer;
import java.util.HashMap;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;

/**
 * Created by chances on 4/7/17.
 */

abstract public class Message extends HashMap<String, Object> {

    void setName(String name) {
        this.put("message.NAME", name);
    }

    public static final MessageCodec<Message> MESSAGE_CODEC = new MessageCodec<Message>() {
        MessageCodec<Object> stdMessageCodec = StandardMessageCodec.INSTANCE;

        @Override
        public ByteBuffer encodeMessage(Message message) {
            return stdMessageCodec.encodeMessage(message);
        }

        @Override
        public Message decodeMessage(ByteBuffer byteBuffer) {
            return (Message) stdMessageCodec.decodeMessage(byteBuffer);
        }
    };
}
