package com.chancesnow.tunage;

import android.os.Bundle;

import com.chancesnow.tunage.interop.Message;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String MAIN_CHANNEL = "com.chancesnow.tunage";
  private static final String MAIN_MESSAGE_CHANNEL = "com.chancesnow.tunage/messages";
  private static final String SPOTIFY_CHANNEL = "com.chancesnow.tunage/spotify";
  private static final String SPOTIFY_MESSAGE_CHANNEL = "com.chancesnow.tunage/spotify/messages";

  private BasicMessageChannel mMainChannel;
  private BasicMessageChannel mSpotifyChannel;

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
                result.notImplemented();
              }
            }
    );

    new MethodChannel(getFlutterView(), SPOTIFY_CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                // TODO: Will I use the old Spotify Player API or the new Spotify Connect Web API?
                result.notImplemented();
              }
            }
    );
  }
}
