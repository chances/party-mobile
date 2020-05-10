import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/theme.dart';
import 'package:party/views/login_page.dart';
import 'package:party/views/party_page.dart';
import 'package:party/views/playlists_page.dart';
import 'package:party/views/startup_page.dart';

class PartyApp extends StatelessWidget {
  PartyApp() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    app.router.define("/", handler: StartupPage.handler);
    app.router.define("/login", handler: LoginPage.handler);
    app.router.define("/party", handler: PartyPage.handler);
    app.router.define("/playlists", handler: PlaylistsPage.handler);
    if (!Constants.isProduction) app.router.printTree();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Party',
      theme: partyTheme,
      onGenerateRoute: app.router.generator,
    );
  }
}
