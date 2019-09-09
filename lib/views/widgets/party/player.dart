import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/views/widgets/add_to_library_button.dart';

class Player extends StatefulWidget {
  final VoidCallback onPause, onResume;
  final bool isMusicFooterShown;

  const Player({Key key, this.onPause, this.onResume, this.isMusicFooterShown})
      : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    var track = app.party.currentTrack;

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
              track.paused ? widget.onResume() : widget.onPause();
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

    return Stack(
      children: <Widget>[
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
        Constants.musicFooter(context, widget.isMusicFooterShown)
      ],
    );
  }
}
