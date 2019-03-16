import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models.dart' as models;
import 'package:party/views/widgets/primary_button.dart';
import 'package:party/views/widgets/splash_prompt.dart';

class BeginPlayback extends StatelessWidget {
  final VoidCallback onShufflePressed;

  BeginPlayback({this.onShufflePressed});

  Future<models.Playlist> _currentPlaylist() {
    return app.api.playlists.get();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
                  var shuffleButton = PrimaryButton('Shuffle Playlist',
                      onPressed: onShufflePressed);
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
      ],
    );
  }
}
