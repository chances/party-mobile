import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Constants {

  static final Color colorPrimary = new Color(0xFF242424);
  static final Color colorPrimaryDark = new Color(0xFF0A0A0A);
  static final Color colorAccent = new Color(0xFF00B957);
  static final Color colorAccentHighlight = new Color(0xFF00D764);
  static final Color colorAccentLight = new Color(0xFFFCFCFC);

  static final Color colorAccentControlHighlight = new Color(0xFF292929);

  static final Color colorAccentLightControl = new Color(0xFFA0A0A0);
  static final Color colorAccentLightControlHighlight = new Color(0xFF797979);

  static final Color statusBarColor = colorPrimary;

  static final Typography typography = new Typography(platform: TargetPlatform.android);

  static final Widget footer = new Positioned(
      bottom: 16.0,
      left: 0.0,
      right: 0.0,
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Padding(
              padding: new EdgeInsets.only(right: 16.0),
              child: new Text("Powered by"),
            ),
            new Image.asset(
              "images/spotify_logo_white.png",
              height: 37.0,
            ),
          ]
      )
  );

  // Interop
  static const String spotifyChannel = "com.chancesnow.party/spotify";
  static const String spotifyMessageChannel =
      "com.chancesnow.party/spotify/messages";
}
