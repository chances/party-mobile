package com.chancesnow.tunage;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import com.google.android.material.snackbar.Snackbar;
import android.util.Log;
import android.view.View;
import android.webkit.CookieManager;

import com.chancesnow.tunage.interop.Message;
import com.chancesnow.tunage.interop.SetAccessTokenStateMessage;
import com.chancesnow.tunage.interop.SetLoginStateMessage;
import com.spotify.sdk.android.authentication.AuthenticationClient;
import com.spotify.sdk.android.authentication.AuthenticationRequest;
import com.spotify.sdk.android.authentication.AuthenticationResponse;

import java.util.Date;
import java.util.UUID;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final int SPOTIFY_AUTH_REQUEST_CODE = 2977; // Tel keys: C-X-S-S
  private static final String CLIENT_ID = "658e37b135ea40bcabd7b3c61c8070f6";
  private static final String REDIRECT_URI = "chancesparty://callback";
  private static final String MAIN_CHANNEL = "com.chancesnow.tunage";
  private static final String MAIN_MESSAGE_CHANNEL = "com.chancesnow.tunage/messages";
  private static final String SPOTIFY_CHANNEL = "com.chancesnow.tunage/spotify";
  private static final String SPOTIFY_MESSAGE_CHANNEL = "com.chancesnow.tunage/spotify/messages";

  private BasicMessageChannel mMainChannel;
  private BasicMessageChannel mSpotifyChannel;

  private UUID mLoginState;
  private boolean mTryingLogin = false;
  private boolean mIsLoggedIn = false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    mMainChannel = new BasicMessageChannel<>(
            getFlutterView(), MAIN_MESSAGE_CHANNEL, Message.MESSAGE_CODEC
    );
    mSpotifyChannel = new BasicMessageChannel<>(
            getFlutterView(), SPOTIFY_MESSAGE_CHANNEL, Message.MESSAGE_CODEC
    );

    new MethodChannel(getFlutterView(), MAIN_CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("getCookies")) {
                  if (!call.hasArgument("url")) {
                    result.error("ARGUMENT", "Cookie url is required argument", null);
                  }

                  String cookie = CookieManager.getInstance().getCookie(
                          (String) call.argument("url")
                  );
                  result.success(cookie);
                } else {
                  result.notImplemented();
                }
              }
            }
    );

    new MethodChannel(getFlutterView(), SPOTIFY_CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("login")) {
                  login();

                  result.success(mTryingLogin);
                } else if (call.method.equals("getCookies")) {
                } else {
                  result.notImplemented();
                }
              }
            }
    );
  }

  private void setLoginState(boolean isLoggedIn) {
    mIsLoggedIn = isLoggedIn;

    if (mSpotifyChannel != null) {
      mSpotifyChannel.send(new SetLoginStateMessage(isLoggedIn));
    }
  }

  public void login() {
    mTryingLogin = true;

    AuthenticationRequest.Builder builder =
            new AuthenticationRequest
                    .Builder(CLIENT_ID, AuthenticationResponse.Type.TOKEN, REDIRECT_URI)
                    .setScopes(new String[]{
                            "user-read-private",
                            "user-library-modify",
                            "playlist-read-private",
                            "streaming"
                    })
                    .setState((mLoginState = UUID.randomUUID()).toString())
                    .setShowDialog(false);

    AuthenticationRequest request = builder.build();

    AuthenticationClient.openLoginActivity(this, SPOTIFY_AUTH_REQUEST_CODE, request);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
    super.onActivityResult(requestCode, resultCode, intent);

    if (requestCode == SPOTIFY_AUTH_REQUEST_CODE) {
      AuthenticationResponse response = AuthenticationClient.getResponse(resultCode, intent);

      mTryingLogin = false;

      switch (response.getType()) {
        case TOKEN:
          String accessToken = response.getAccessToken();
          Date now = new Date();
          Date tokenExpiryDate = new Date(now.getTime() + (response.getExpiresIn() * 1000));

          setLoginState(true);
          mSpotifyChannel.send(new SetAccessTokenStateMessage(accessToken, tokenExpiryDate));

          new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
              //gotoParty();
              // TODO: Tell Dart client to go to party activity
            }
          }, 750);

          break;

        case ERROR:
          // Handle error response

          Snackbar snackbar = Snackbar
                  .make(this.getFlutterView(), "Could not login", Snackbar.LENGTH_LONG)
                  .setAction("RETRY", new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                      login();
                    }
                  })
                  .addCallback(new Snackbar.Callback() {
                    // Show the login button if the user did not immediately retry
                    @Override
                    public void onDismissed(Snackbar snackbar, int event) {
                      super.onDismissed(snackbar, event);

                      if (!mTryingLogin) {
                        setLoginState(false);
                      }
                    }
                  });

          snackbar.show();

          Log.d("d", response.getError()); // AUTHENTICATION_SERVICE_UNAVAILABLE ?
          Log.d("d", response.getCode());
          break;

        // Most likely auth flow was cancelled
        default:
          // TODO: Handle other cases?

          setLoginState(false);
      }
    }
  }
}
