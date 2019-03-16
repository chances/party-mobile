import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:party/models/track.dart';
import 'package:party/views/widgets/add_to_library_button.dart';
import 'package:party/views/widgets/guest_list.dart';
import 'package:party/views/widgets/party/start_party.dart';
import 'package:party/views/widgets/splash_prompt.dart';
import 'package:spotify/spotify_io.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models.dart' as models;
import 'package:party/models/party.dart';
import 'package:party/models/music.dart';
import 'package:party/views/widgets/primary_button.dart';
import 'package:party/views/playlists_page.dart';

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

  Future<models.Playlist> _currentPlaylist() {
    return app.api.playlists.get();
  }

  Future<Null> _play() async {
    await app.api.playback.play(true);
    if (app.party.currentTrack == null) {
      app.party = await app.api.party.get();
    }

    setState(() {
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
      selectedTab = new Stack(
        children: app.party.currentTrack == null
            ? buildBeginPlayback(context)
            : buildPlayer(context),
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
                  Party party = await app.endParty(context);
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

  List<Widget> buildBeginPlayback(BuildContext context) {
    return [
      new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Padding(
              padding: new EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: new SplashPrompt(
                'Play some music',
                ['Ask your guests to contribute after the music starts.'],
              ),
            ),
            FutureBuilder(
              future: _currentPlaylist(),
              builder: (context, AsyncSnapshot<models.Playlist> snapshot) {
                var shuffleButton =
                    PrimaryButton('Shuffle Playlist', onPressed: _play);
                if (snapshot.connectionState == ConnectionState.none)
                  return shuffleButton;
                var loading =
                    snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.waiting;
                // TODO: Handle API errors
                if (snapshot.hasError) return shuffleButton;
                var durationEstimate = snapshot.hasData
                    ? Duration(hours: snapshot.data.totalTracks * 4)
                    : null;
                return loading
                    ? Constants.loadingIndicator
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 152.0,
                              maxWidth: 152.0,
                            ),
                            child: Constants.fadeInImage(
                                snapshot.data.images.first.url),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    snapshot.data.name,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ),
                                Text(
                                  '~${durationEstimate.inDays} days',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          shuffleButton,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
      Constants.musicFooter(context, false)
    ];
  }

  List<Widget> buildPlayer(BuildContext context) {
    PlayingTrack track = app.party.currentTrack;

    var controls = [
      new AddToLibraryButton(app, track, addedToLibrary: () {
        setState(() {
          app.party.currentTrack.isAdded = true;
        });
      }),
      new Padding(
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
        child: new AnimatedCrossFade(
          crossFadeState: track.isQueued
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Constants.trackChangeTransition,
          firstChild: new Padding(
            padding: new EdgeInsets.all(2.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints.loose(new Size.fromRadius(22.0)),
              child: Constants.loadingIndicator,
            ),
          ),
          secondChild: new IconButton(
            icon: new Icon(track.paused ? Icons.play_arrow : Icons.pause),
            iconSize: 48.0,
            tooltip: track.paused ? 'Resume' : 'Play',
            onPressed: () {
              track.paused ? _resume() : _pause();
            },
          ),
        ),
      ),
      new IconButton(
        icon: new Icon(Icons.skip_next),
        iconSize: 36.0,
        tooltip: 'Next',
        onPressed: null,
      ),
    ];

    return [
      new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new ConstrainedBox(
              child: Constants.fadeTransitionImage(
                  track.images.first.url, BoxFit.scaleDown),
              constraints:
                  new BoxConstraints(maxWidth: 180.0, minHeight: 180.0),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new Column(
                children: [
                  new Text(track.name,
                      style: Theme.of(context).textTheme.headline),
                  new Text(track.artists.first.name,
                      style: Theme.of(context).textTheme.subhead),
                  new Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: controls,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
      Constants.musicFooter(context, _selectedTab == PartyTab.music)
    ];
  }
}
