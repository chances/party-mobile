package com.chancesnow.party.interop;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * Created by chances on 6/20/17.
 */

public class SetAccessTokenStateMessage extends Message {
    private static String SET_TOKEN_STATE = "spotify.SET_TOKEN_STATE";
    private static String ACCESS_TOKEN = "spotify.ACCESS_TOKEN";
    private static String EXPIRES_AT = "spotify.EXPIRES_AT";

    public SetAccessTokenStateMessage(String accessToken, Date expiresInDate) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'");
        format.setTimeZone(TimeZone.getTimeZone("UTC"));

        setName(SET_TOKEN_STATE);
        this.put(ACCESS_TOKEN, accessToken);
        this.put(EXPIRES_AT, format.format(expiresInDate));
    }
}
