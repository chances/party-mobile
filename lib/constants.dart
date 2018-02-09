import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:party/app_context.dart';

typedef void MenuEntrySelected(String value);

class Constants {

  static final Color colorPrimary = const Color(0xFF242424);
  static final Color colorPrimaryDark = const Color(0xFF0A0A0A);
  static final Color colorAccent = const Color(0xFF00B957);
  static final Color colorAccentHighlight = const Color(0xFF00D764);
  static final Color colorAccentLight = const Color(0xFFFCFCFC);

  static final Color colorAccentControlHighlight = const Color(0xFF292929);

  static final Color colorAccentLightControl = const Color(0xFFA0A0A0);
  static final Color colorAccentLightControlHighlight = const Color(0xFF797979);

  static final Color statusBarColor = colorPrimary;

  static final Typography typography = new Typography(platform: TargetPlatform.android);

  static final loadingColorAnimation =
    const AlwaysStoppedAnimation<Color>(const Color(0xFF00B957));
  static final Widget loading = new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      new CircularProgressIndicator(
        valueColor: loadingColorAnimation,
      ),
    ],
  );

  static final double footerHeight = 53.0;

  static Widget footer(BuildContext context, [double opacity = 1.0]) {
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.body1
        .copyWith(decoration: TextDecoration.none);

    return new Hero(
        tag: 'spotify-power',
        child: new Padding(
            padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Padding(
                    padding: new EdgeInsets.only(right: 10.0),
                    child: new Text(
                      'Powered by',
                      style: textStyle,
                    ),
                  ),
                  new Image.asset(
                    'images/spotify_logo_white.png',
                    height: 37.0,
                  ),
                ]
            )
        ),
    );
  }

  static Widget logoutMenu(BuildContext context, [List<PopupMenuEntry<String>> otherItems, MenuEntrySelected otherItemSelected]) {
    return new PopupMenuButton(
      onSelected: (String value) {
        if (value == 'logout') {
          // TODO: Add confirm dialog
          app.logout(context);
        } else if (otherItems != null && otherItemSelected != null) {
          otherItemSelected(value);
        }
      },
      itemBuilder: (BuildContext context) {
        var items = otherItems == null ? <PopupMenuEntry<String>>[] : otherItems;
        items.addAll(<PopupMenuEntry<String>>[
          const PopupMenuItem(value: 'logout', child: const Text('Logout'))
        ]);
        return items;
      },
    );
  }

  // API & Authentication
  static const String partyApi = "http://10.0.0.20:3005";
//  static const String partyApi = "https://party.chancesnow.me";

  // Interop
  static const String mainChannel = "com.chancesnow.party";
  static const String mainMessageChannel = "com.chancesnow.party/messages";
  static const String spotifyChannel = "com.chancesnow.party/spotify";
  static const String spotifyMessageChannel =
      "com.chancesnow.party/spotify/messages";
}
