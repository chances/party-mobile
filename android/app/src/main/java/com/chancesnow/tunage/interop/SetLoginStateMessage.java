package com.chancesnow.tunage.interop;

/**
 * Created by chances on 4/7/17.
 */

public class SetLoginStateMessage extends Message {
    private static String SET_LOGIN_STATE = "spotify.SET_LOGIN_STATE";
    private static String IS_LOGGED_IN = "spotify.IS_LOGGED_IN";

    public SetLoginStateMessage(boolean isLoggedIn) {
        setName(SET_LOGIN_STATE);
        this.put(IS_LOGGED_IN, isLoggedIn);
    }
}
