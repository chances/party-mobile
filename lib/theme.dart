import 'package:flutter/material.dart';

import 'package:party/constants.dart';

final partyTheme = new ThemeData.dark().copyWith(
    primaryColor: Constants.colorPrimary,
    accentColor: Constants.colorAccent,
    backgroundColor: Constants.colorPrimary,

    iconTheme: new IconThemeData(color: Constants.colorAccentLight),
    textSelectionHandleColor: Constants.colorAccent
);
