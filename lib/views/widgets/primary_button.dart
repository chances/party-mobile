import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:party/constants.dart';
import 'package:party/views/widgets/rounded_button.dart';

class PrimaryButton extends StatelessWidget {
  /// Creates a rounded button.
  PrimaryButton(this.label, {
    Key key,
    this.elevation,
    this.highlightElevation,
    @required this.onPressed,
  }) : super(key: key);

  final String label;

  /// The z-coordinate at which to place this button. This controls the size of
  /// the shadow below the button.
  ///
  /// Defaults to 0.
  ///
  /// See also:
  ///
  ///  * [FlatButton], a material button specialized for the case where the
  ///    elevation is zero.
  ///  * [RaisedButton], a material button specialized for the case where the
  ///    elevation is non-zero.
  final double elevation;

  /// The z-coordinate at which to place this button when highlighted. This
  /// controls the size of the shadow below the button.
  ///
  /// Defaults to 0.
  ///
  /// See also:
  ///
  ///  * [elevation], the default elevation.
  final double highlightElevation;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new RoundedButton(
        color: Constants.colorAccent,
        highlightColor: Constants.colorAccent,
        splashColor: Constants.colorAccentHighlight,
        height: 48.0,
        padding: new EdgeInsets.only(left: 36.0, right: 36.0),
        elevation: elevation,
        highlightElevation: highlightElevation,
        onPressed: onPressed,
        child: new Text(
            label.toUpperCase(),
        )
    );
  }
}
