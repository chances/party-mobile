import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:party/app_context.dart';

enum Environment { Production, Staging, Development }

typedef void MenuEntrySelected(String value);

const _authDomain =
    String.fromEnvironment('AUTH_ZERO_DOMAIN', defaultValue: null);
const _authClientId =
    String.fromEnvironment('AUTH_ZERO_CLIENT_ID', defaultValue: null);

String _fromEnvironmentOrDie(String key, String value) {
  if (value == null || value.length == 0) {
    var message = StringBuffer();
    message.write("Expected compile-time environment declaration '$key'");
    message.writeln(", i.e. --dart-define=$key=<value>");
    if (Constants.isProduction) {
      throw new StateError(message.toString());
    } else {
      throw new AssertionError(message.toString());
    }
  }
  return value;
}

class AuthorizationConstants {
  static String _domain =
      _fromEnvironmentOrDie('AUTH_ZERO_DOMAIN', _authDomain);
  static String _clientId =
      _fromEnvironmentOrDie('AUTH_ZERO_CLIENT_ID', _authClientId);

  String domain = _domain;
  String clientId = _clientId;
  String tokenEndpoint = '$_domain/oauth/token';

  String authorizeWithSpotifyCallback = 'tunage://auth/callback';
  String authorizeWithSpotifyEndpoint =
      '$_authDomain/authorize/?connection=Spotify-Tunage';
}

class Constants {
  // Environment Config
  static Map<String, String> get env => DotEnv().env;
  static Environment get environment => env.containsKey('MODE') &&
          Environment.values.map((e) => e.toString()).contains(env['MODE'])
      ? Environment.values
          .firstWhere((element) => element.toString() == env['MODE'])
      : bool.fromEnvironment('dart.vm.product')
          ? Environment.Production
          : Environment.Development;
  static bool isProduction = environment == Environment.Production;

  // Authentication & API
  static var auth = AuthorizationConstants();
  static String get partyApi => env.containsKey('PARTY_API')
      ? env['PARTY_API']
      : 'https://api.tunage.app';

  // Interop
  static const String mainChannel = "com.chancesnow.tunage";
  static const String mainMessageChannel = "com.chancesnow.tunage/messages";
  static const String spotifyChannel = "com.chancesnow.tunage/spotify";
  static const String spotifyMessageChannel =
      "com.chancesnow.tunage/spotify/messages";

  // Theme
  static const Color colorPrimary = const Color(0xFF242424);
  static const Color colorPrimaryDark = const Color(0xFF0A0A0A);
  static const Color colorAccent = const Color(0xFF9B58B5);
  static const Color colorAccentHighlight = const Color(0xFF00D764);
  static const Color colorAccentLight = const Color(0xFFFCFCFC);

  static const Color colorBrandGradientBlue = const Color(0xFF298CC7);
  static const Color colorBrandGradientPurple = const Color(0xFF9B58B5);

  static const Color colorAccentControlHighlight = const Color(0xFF292929);

  static const Color colorAccentLightControl = const Color(0xFFA0A0A0);
  static const Color colorAccentLightControlHighlight = const Color(0xFF797979);

  static const Color statusBarColor = colorPrimary;

  static final Typography typography =
      new Typography(platform: TargetPlatform.android);

  static final loadingColorAnimation =
      const AlwaysStoppedAnimation<Color>(colorAccent);
  static final CircularProgressIndicator loadingIndicator =
      new CircularProgressIndicator(
    valueColor: loadingColorAnimation,
  );
  static final CircularProgressIndicator loadingIndicatorWhite =
      new CircularProgressIndicator(
    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
  );
  static final Widget loading = new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [loadingIndicator],
  );

  static final double footerHeight = 53.0;

  static const Duration trackChangeTransition =
      const Duration(milliseconds: 300);

  static FadeInImage fadeTransitionImage(String image,
      [BoxFit fit, Duration fadeDuration = trackChangeTransition]) {
    return new FadeInImage.assetNetwork(
      image: image,
      placeholder: Assets.img_placeholder,
      fadeInDuration: fadeDuration,
      fadeOutDuration: fadeDuration,
    );
  }

  static FadeInImage fadeInImage(String image,
      [Duration fadeInDuration = const Duration(milliseconds: 250)]) {
    return new FadeInImage.assetNetwork(
      image: image,
      placeholder: Assets.img_placeholder,
      fadeOutDuration: Duration.zero,
      fadeInDuration: fadeInDuration,
    );
  }

  static Widget footer(BuildContext context, [bool hushed = false]) {
    var theme = Theme.of(context);
    var textStyle =
        theme.textTheme.body1.copyWith(decoration: TextDecoration.none);
    if (hushed) {
      textStyle = textStyle.copyWith(color: theme.textTheme.caption.color);
    }

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
                new Opacity(
                  opacity: hushed ? 0.6 : 1.0,
                  child: new Image.asset(
                    Assets.img_spotify_white,
                    height: 37.0,
                  ),
                ),
              ])),
    );
  }

  static musicFooter(BuildContext context, bool shown) {
    return new AnimatedPositioned(
        bottom: shown ? 0.0 : 0.0 - (footerHeight * 3),
        left: 0.0,
        right: 0.0,
        curve: shown ? Curves.easeOut : Curves.easeIn,
        child: footer(context, true),
        duration: new Duration(milliseconds: 400));
  }

  static Widget logoutMenu(BuildContext context,
      [List<PopupMenuEntry<String>> otherItems,
      MenuEntrySelected otherItemSelected]) {
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
        var items =
            otherItems == null ? <PopupMenuEntry<String>>[] : otherItems;
        items.addAll(<PopupMenuEntry<String>>[
          const PopupMenuItem(value: 'logout', child: const Text('Logout'))
        ]);
        return items;
      },
    );
  }
}
