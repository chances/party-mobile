import 'package:flutter/material.dart';
import 'package:party/models/party.dart';
import 'package:party/views/widgets/splash_prompt.dart';

class GuestList extends StatelessWidget {
  final List<Guest> guests;

  GuestList(this.guests);

  @override
  Widget build(BuildContext context) {
    if (guests != null && guests.length > 0) {
      return new ListView.builder(
        itemBuilder: (context, index) {
          return new ListTile(
            enabled: false,
            title: new Text(guests[index].name),
          );
        },
        itemCount: guests.length,
      );
    }

    // Prompt the user to invite their guests to join the party
    return new Stack(
      children: <Widget>[
        new Center(
          child: new SplashPrompt('Invite your guests', [
            'No guests have checked in to your party.',
            'Ask your guests to contribute music by adding songs to the song list.'
          ]),
        )
      ],
    );
  }
}
