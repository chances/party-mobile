import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:spotify/spotify_io.dart' show PlaylistSimple;

class PlaylistsPage extends StatefulWidget {
  PlaylistsPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        app.logoutIfNecessary(context);
        
        return new PlaylistsPage();
      }
  );

  @override
  _PlaylistsPageState createState() => new _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  bool _loading = app.playlists.isEmpty;
  bool _forceLoad = false;

  Future<Iterable<PlaylistSimple>> get _loadPlaylists {
    if (app.playlists.length == 0 || _forceLoad) {
      _forceLoad = false;
      var futurePlaylists = app.spotify.client(context).playlists.me.all();
      return futurePlaylists.then((playlists) {
        setState(() {
          _loading = false;
        });
        app.playlists.clear();
        app.playlists.addAll(playlists.where((p) {
          return p.owner.id == app.user.id;
        }));
        return playlists;
      });
    } else {
      return new Future.value(app.playlists);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      Constants.logoutMenu(context)
    ];

    if (!_loading) {
      actions.insert(0, new IconButton(
        icon: new Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {
          setState(() {
            _forceLoad = true;
            _loading = true;
          });
        },
      ));
    }

    final media = MediaQuery.of(context);

    final bottomHelperText = app.hasParty
        ? 'Pick one to mix into the queue'
        : 'Pick one to play during the party';
    final bottomHelperTextStyle = Theme.of(context).textTheme.body1;
    final bottomHelper = new Text(
      bottomHelperText,
      style: bottomHelperTextStyle,
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Your Playlists"),
          actions: actions,
          backgroundColor: Constants.statusBarColor,
          elevation: 4.0,
          bottom: new PreferredSize(
              child: new Container(
                padding: new EdgeInsets.only(
                  bottom: 16.0,
                  left: 72.0,
                ),
                width: media.size.width,
                alignment: Alignment.topLeft,
                child: bottomHelper,
              ),
              preferredSize: new Size(
                  media.size.width,
                  bottomHelperTextStyle.fontSize + 16.0
              )
          ),
        ),
        bottomNavigationBar: Constants.footer,
        body: buildPlaylistView(context),
    );
  }

  Widget buildPlaylistView(BuildContext context) {
    if (!_loading && app.playlists.isNotEmpty) {
      return buildPlaylistListView(context);
    } else if (!_loading && app.playlists.isEmpty) {
      return buildPlaylistListView(
          context, 'You have no Spotify playlists'
      );
    }

    return new FutureBuilder<Iterable<PlaylistSimple>>(
        future: _loadPlaylists,
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<PlaylistSimple>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return new Column(children: [
                new Expanded(child: Constants.loading)
              ], crossAxisAlignment: CrossAxisAlignment.stretch);
            default:
              return buildPlaylistListView(
                  context,
                  snapshot.hasError ? snapshot.error : null
              );
          }
        }
    );
  }

  Widget buildPlaylistListView(BuildContext context, [Object error]) {
    var playlistsOrError = error == null
        ? new Column(children: [
      new Expanded(child: new ListView(
          children: ListTile.divideTiles(
              context: context,
              tiles: app.playlists.map((playlist) {
                return new ListTile(
                  leading: new Image.network(
                      playlistSuitableImageUrl(playlist)
                  ),
                  title: new Text(
                    playlist.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: new Text(playlistSubtitle(playlist)),
                );
              }).toList()
          ).toList()
      ))
    ])
        : new Center(child: new Text(error));

    return playlistsOrError;
  }

  String playlistSuitableImageUrl(PlaylistSimple playlist) {
    return playlist.images
        .where((img) => img.width < 500).first
        .url;
  }

  String playlistSubtitle(PlaylistSimple playlist) {
    int total = playlist.tracksLink.total;
    String suffix = total == 1 ? 'song' : 'songs';
    return '$total $suffix';
  }
}
