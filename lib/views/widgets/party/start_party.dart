import 'package:flutter/material.dart';

import 'package:party/views/widgets/primary_button.dart';
import 'package:party/views/widgets/splash_prompt.dart';

class StartParty extends StatelessWidget {
  final VoidCallback onStartPressed;

  StartParty({this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Center(
            child: new Column(
          children: [
            new Padding(
              padding: new EdgeInsets.only(bottom: 16.0),
              child: new SplashPrompt('Get this party started',
                  ['Host a party with music, games, and fun!']),
            ),
            new PrimaryButton('Start', onPressed: onStartPressed)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )),
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
      ],
    );
  }
}
