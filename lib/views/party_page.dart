import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:party/views/playlists_page.dart';
import 'package:spotify/spotify_io.dart';

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

enum PartyTab {
  music,
  guests,
  games,
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

  Future<Null> get _startParty {
    return null;
  }

  void _selectPlaylist() {
    // TODO: Refactor this elsewhere
    Navigator.of(context)
        .push(new MaterialPageRoute<PlaylistSimple>(builder: (BuildContext context) {
          return PlaylistsPage.handler.handlerFunc(context, null);
    })).then((PlaylistSimple playlist) {
      if (playlist == null) return;

      // TODO: Call server /party/start (w/ host's name and playlist ID)
    });
  }

  @override
  Widget build(BuildContext context) {
    var content = app.hasParty
        ? buildSelectPlaylist(context)
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
      Constants.logoutMenu(context, <PopupMenuEntry<String>>[
        const PopupMenuItem(value: 'end', child: const Text('End Party')),
        const PopupMenuDivider(),
      ], (value) {
        if (value == 'end') {
          setState(() async {
            app.party = await app.endParty();
          });
        }
      })
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
              new PrimaryButton('Start', onPressed: _selectPlaylist)
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
