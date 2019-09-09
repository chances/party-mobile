import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:spotify/spotify_io.dart' show PlaylistSimple;

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/music.dart';
import 'package:party/views/playlists_page.dart';
import 'package:party/views/widgets/guest_list.dart';
import 'package:party/views/widgets/party/begin_playback.dart';
import 'package:party/views/widgets/party/player.dart';
import 'package:party/views/widgets/party/start_party.dart';

class PartyPage extends StatefulWidget {
  PartyPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PartyPage();
  });

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
      buildDefaultAppBar: buildAppBar,
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
    return Navigator.of(context).push(
        new MaterialPageRoute<PlaylistSimple>(builder: (BuildContext context) {
      return PlaylistsPage.handler.handlerFunc(context, null);
    }));
  }

  Future<Null> _play() async {
    await app.api.playback.play(true);
    if (app.party.currentTrack == null) {
      app.party = await app.api.party.get();
    }

    setState(() async {
      app.party.currentTrack = await app.api.playback.play(true);
      app.party.currentTrack.paused = false;
    });
  }

  Future<Null> _pause() async {
    await app.api.playback.pause(app.party.currentTrack.elapsed);
    var party = await app.api.party.get();
    setState(() {
      app.party = party;
    });
  }

  Future<Null> _resume() async {
    await app.api.playback.resume();
    var party = await app.api.party.get();
    setState(() {
      app.party = party;
    });
  }

  Future<Null> _skip() async {
    await app.api.playback.skip();
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedTab = new Stack(
      children: [new Center(child: Constants.loadingIndicator)],
    );

    if (_selectedTab == PartyTab.music && app.hasParty) {
      selectedTab = app.party.currentTrack == null
          ? BeginPlayback(onShufflePressed: _play)
          : Player(
              onPause: _pause,
              onResume: _resume,
              isMusicFooterShown: _selectedTab == PartyTab.music,
            );
    }

    if (_selectedTab == PartyTab.guests && app.hasParty) {
      selectedTab = new GuestList(app.party.guests);
    }

    if (searchBar.isSearching.value) {
      selectedTab = new Column(
        children: <Widget>[
          new Expanded(child: new Center(child: new Text('Search'))),
          Constants.footer(context, true)
        ],
      );
    }

    var content =
        app.hasParty ? selectedTab : StartParty(onStartPressed: _startParty);

    final BottomNavigationBar bottomNavBar = app.hasParty
        ? new BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _selectedTab = PartyTab.values[index];
              });
            },
            currentIndex: _selectedTab.index,
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(Icons.music_note),
                title: new Text('Music'),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.people),
                title: new Text('Guests'),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.videogame_asset),
                title: new Text('Games'),
              )
            ],
          )
        : null;

    return new Scaffold(
      appBar: searchBar.build(context),
      body: content,
      bottomNavigationBar: searchBar.isSearching.value ? null : bottomNavBar,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final actions = [
      app.hasParty
          ? Constants.logoutMenu(
              context,
              <PopupMenuEntry<String>>[
                const PopupMenuItem(
                    value: 'end', child: const Text('End Party')),
                const PopupMenuDivider(),
              ],
              (value) async {
                if (value == 'end') {
                  var party = await app.endParty(context);
                  setState(() {
                    app.party = party;
                  });
                }
              },
            )
          : Constants.logoutMenu(context)
    ];

    if (app.hasParty) {
      actions.insert(
        0,
        new IconButton(
          icon: new Icon(Icons.add),
          tooltip: 'Add a song',
          onPressed: () {
            searchBar.beginSearch(context);
          },
        ),
      );
    }

    return new AppBar(
      title: new Text(app.hasParty ? 'Your Party' : 'Start a Party'),
      backgroundColor: Constants.statusBarColor,
      elevation: 4.0,
      actions: actions,
    );
  }

  List<Widget> buildLoading(BuildContext context) {
    return [new Center(child: Constants.loading)];
  }
}
