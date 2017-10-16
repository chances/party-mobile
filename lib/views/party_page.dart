import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/views/widgets/primary_button.dart';

class PartyPage extends StatefulWidget {
  PartyPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new PartyPage();
      }
  );

  @override
  _PartyPageState createState() => new _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  SearchBar searchBar;
  bool _loading = true;

  _PartyPageState() {
    searchBar = new SearchBar(
        hintText: 'Search for a song',
        setState: setState,
        buildDefaultAppBar: buildAppBar
    );
  }

  Future<Null> get _loadUser {
    return null;
  }

  void _selectPlaylist() {
    Navigator.of(context).pushNamed('/playlists')
        .then((_) {

    });
  }

  @override
  Widget build(BuildContext context) {
    var content = app.hasParty
        ? buildSelectPlaylist(context)
        : buildStartParty(context);

    return new Scaffold(
      appBar: searchBar.build(context),
      bottomNavigationBar: Constants.footer,
      body: new Stack(children: content),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final actions = [
      Constants.logoutMenu(context)
    ];

    if (app.hasParty) {
      actions.insert(0, new IconButton(
        icon: new Icon(Icons.add),
        tooltip: 'Add a song',
        onPressed: () {
          searchBar.beginSearch(context);
        },
      ));
    }

    return new AppBar(
      title: new Text(app.hasParty ? 'Your Party' : 'Start a Party'),
      backgroundColor: Constants.statusBarColor,
      elevation: 4.0,
      actions: actions,
      bottom: null, // TODO: Tab switcher; 'Music', 'Guests', 'Games'
    );
  }

  List<Widget> buildLoading(BuildContext context) {
    return [
      new Center(child: Constants.loading)
    ];
  }

  List<Widget> buildStartParty(BuildContext context) {
    return [
      new Center(
          child: new Column(
            children: [
              new Padding(
                padding: new EdgeInsets.only(bottom: 16.0),
                child: new Column(children: [
                  new Text(
                    'Host a party with music, games, and fun!',
                    style: Theme.of(context).textTheme.subhead,
                  )
                ]),
              ),
              new PrimaryButton('Start', onPressed: _selectPlaylist)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
      )
    ];
  }

  List<Widget> buildSelectPlaylist(BuildContext context) {
    return [
      new Center(
          child: new Column(
            children: [
              new Padding(
                padding: new EdgeInsets.only(bottom: 16.0),
                child: new Column(children: [
                  new Text(
                    'Play your favorite playlist',
                    style: Theme.of(context).textTheme.headline,
                  ),
//                  new Text(
//                    '',
//                    style: Theme.of(context).textTheme.body1,
//                  )
                ]),
              ),
              new PrimaryButton('Select Playlist', onPressed: _selectPlaylist)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
      )
    ];
  }
}
