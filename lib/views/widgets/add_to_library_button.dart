import 'dart:async';

import 'package:flutter/material.dart';
import 'package:party/app_context.dart';
import 'package:party/models/track.dart';
import 'package:spotify/spotify_io.dart';

class AddToLibraryButton extends StatelessWidget {
  final AppContext app;
  final PlayingTrack track;
  final VoidCallback addedToLibrary;

  AddToLibraryButton(this.app, this.track, {this.addedToLibrary});

  Future<Null> _addToLibrary(BuildContext context, PlayingTrack track) async {
    try {
      await app.spotify.client(context).tracks.me.saveOne(track.id);
      if (track.id == app.party.currentTrack?.id) {
        if (addedToLibrary != null) {
          addedToLibrary();
        }
      }
    } on SpotifyException catch(e) {
      showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(
            'Could Not Add Song to Your Library',
            style: Theme.of(context).textTheme.title
          ),
          children: [
            new Text(e.message, style: Theme.of(context).textTheme.body1)
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (track.isAdded) {
      return _addButton(context, true, false, null);
    }

    return new FutureBuilder<bool>(
        future: app.spotify.client(context).tracks.me.containsOne(track.id),
        builder: (context, snapshot) {
          var isAdded = snapshot.hasData ? snapshot.data : false;
          var isChecking = snapshot.connectionState == ConnectionState.waiting;
          var notAdded = !isAdded && snapshot.connectionState == ConnectionState.done;
          var onPressed = notAdded ? () => _addToLibrary(context, track) : null;
          return _addButton(context, isAdded, isChecking, onPressed);
        },
      );
  }

  Widget _addButton(BuildContext context, bool isAdded, bool isChecking, VoidCallback onPressed) {
    return new IconButton(
      icon: new Icon(isAdded ? Icons.check : Icons.add),
      iconSize: 32.0,
      tooltip: isAdded ? 'Added to Library' : 'Add to Library',
      disabledColor: isChecking ? null : Theme.of(context).textTheme.button.color,
      onPressed: onPressed,
    );
  }
}
