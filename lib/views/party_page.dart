import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:spotify/spotify_io.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/party.dart';
import 'package:party/models/music.dart';
import 'package:party/views/widgets/primary_button.dart';
import 'package:party/views/playlists_page.dart';

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
  PartyTab _selectedTab = PartyTab.music;

  _PartyPageState() {
    searchBar = new SearchBar(
        hintText: 'Search for a song',
        setState: setState,
        buildDefaultAppBar: buildAppBar
    );
  }

  Future<Null> _startParty() async {
    PlaylistSimple playlist = await _selectPlaylist();
    if (playlist == null) return;

    var party = await app.api.party.start(app.user.displayName, playlist.id);
    setState(() {
      app.party = party;
    });
  }

  Future<PlaylistSimple> _selectPlaylist() {
    // TODO: Refactor this elsewhere?
    return Navigator.of(context)
        .push(new MaterialPageRoute<PlaylistSimple>(builder: (BuildContext context) {
          return PlaylistsPage.handler.handlerFunc(context, null);
    }));
  }

  Future<Null> _play() async {
    await app.api.playback.play(true);
  }

  Future<Null> _pause() async {
    await app.api.playback.pause(app.party.currentTrack.elapsed);
  }

  Future<Null> _resume() async {
    await app.api.playback.resume();
  }

  Future<Null> _skip() async {
    await app.api.playback.skip();
  }

  @override
  Widget build(BuildContext context) {
    var content = app.hasParty
        ? app.party.currentTrack == null ? buildBeginPlayback(context) : null
        : buildStartParty(context);

    final BottomNavigationBar bottomNavBar = app.hasParty
        ? new BottomNavigationBar(onTap: (index) {
          setState(() {
            _selectedTab = PartyTab.values[index];
          });
        },
        currentIndex: _selectedTab.index,
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.music_note),
              title: new Text('Music')
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.people),
              title: new Text('Guests')
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.videogame_asset),
              title: new Text('Games')
          )
        ])
        : null;

    return new Scaffold(
      appBar: searchBar.build(context),
      body: new Stack(children: content),
      bottomNavigationBar: bottomNavBar,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final actions = [
      app.hasParty
        ? Constants.logoutMenu(context, <PopupMenuEntry<String>>[
          const PopupMenuItem(value: 'end', child: const Text('End Party')),
          const PopupMenuDivider(),
        ], (value) async {
          if (value == 'end') {
            Party party = await app.endParty(context);
            setState(() {
              app.party = party;
            });
          }
        })
        : Constants.logoutMenu(context)
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
              new PrimaryButton('Start', onPressed: _startParty)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
      ),
      new Positioned(
        bottom: 16.0,
        left: 0.0,
        right: 0.0,
        child: new Row(
          children: [
            new RaisedButton(
              onPressed: () {},
              child: new Text('Previous Parties'),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    ];
  }

  List<Widget> buildBeginPlayback(BuildContext context) {
    return [
      new Center(
          child: new Column(
            children: [
              new Padding(
                padding: new EdgeInsets
                    .only(bottom: 16.0, left: 16.0, right: 16.0),
                child: new Column(children: [
                  new Text(
                    'Play some music',
                    style: Theme.of(context).textTheme.headline,
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 4.0),
                    child: new Text(
                      'Ask your guests to contribute after the music starts.',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ]),
              ),
              new PrimaryButton('Shuffle Play', onPressed: _play)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
      ),
      new AnimatedPositioned(
          bottom: _selectedTab == PartyTab.music
              ? 0.0
              : 0.0 - (Constants.footerHeight * 3),
          left: 0.0,
          right: 0.0,
          curve: _selectedTab == PartyTab.music
              ? Curves.easeOut
              : Curves.easeIn,
          child: Constants.footer(context),
          duration: new Duration(milliseconds: 400)
      )
    ];
  }
}
