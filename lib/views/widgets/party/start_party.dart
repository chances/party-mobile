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
        Center(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: SplashPrompt('Get this party started',
                  ['Host a party with music, games, and fun!']),
            ),
            PrimaryButton('Start', onPressed: onStartPressed)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )),
        Positioned(
          bottom: 16.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            children: [
              RaisedButton(
                onPressed: () {},
                child: Text('Previous Parties'),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
    );
  }
}
