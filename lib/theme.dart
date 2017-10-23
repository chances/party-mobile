import 'package:flutter/material.dart';

import 'package:party/constants.dart';

final partyTheme = new ThemeData.dark().copyWith(
    primaryColor: Constants.colorPrimary,
    accentColor: Constants.colorAccent,
    backgroundColor: Constants.colorPrimary,
    scaffoldBackgroundColor: Constants.colorPrimaryDark,

    buttonColor: Constants.colorAccentLightControl,
    highlightColor: Constants.colorAccentLightControlHighlight,

    selectedRowColor: Constants.colorAccentLightControlHighlight,
    dividerColor: Constants.colorAccentControlHighlight,

    iconTheme: new IconThemeData(color: Constants.colorAccentLight),
    textSelectionHandleColor: Constants.colorAccent
);
