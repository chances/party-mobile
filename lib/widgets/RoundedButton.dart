import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedButton extends StatefulWidget {
  /// Creates a rounded button.
  const RoundedButton({
    Key key,
    this.colorBrightness,
    this.textTheme,
    this.textColor,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.elevation,
    this.highlightElevation,
    this.minWidth,
    this.height,
    this.padding,
    @required this.onPressed,
    this.child
  }) : super(key: key);

  /// The theme brightness to use for this button.
  ///
  /// Defaults to the brightness from [ThemeData.brightness].
  final Brightness colorBrightness;

  /// The color scheme to use for this button's text.
  ///
  /// Defaults to the button color from [ButtonTheme].
  final ButtonTextTheme textTheme;

  /// The color to use for this button's text.
  final Color textColor;

  /// The primary color of the button, as printed on the [Material], while it
  /// is in its default (unpressed, enabled) state.
  ///
  /// Defaults to null, meaning that the color is automatically derived from the [Theme].
  ///
  /// Typically, a material design color will be used, as follows:
  ///
  /// ```dart
  ///  new MaterialButton(
  ///    color: Colors.blue[500],
  ///    onPressed: _handleTap,
  ///    child: new Text('DEMO'),
  ///  ),
  /// ```
  final Color color;

  /// The primary color of the button when the button is in the down (pressed) state.
  /// The splash is represented as a circular overlay that appears above the
  /// [highlightColor] overlay. The splash overlay has a center point that matches
  /// the hit point of the user touch event. The splash overlay will expand to
  /// fill the button area if the touch is held for long enough time. If the splash
  /// color has transparency then the highlight and button color will show through.
  ///
  /// Defaults to the splash color from the [Theme].
  final Color splashColor;

  /// The secondary color of the button when the button is in the down (pressed)
  /// state. The higlight color is represented as a solid color that is overlaid over the
  /// button color (if any). If the highlight color has transparency, the button color
  /// will show through. The highlight fades in quickly as the button is held down.
  ///
  /// Defaults to the highlight color from the [Theme].
  final Color highlightColor;

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

  /// The smallest horizontal extent that the button will occupy.
  ///
  /// Defaults to the value from the current [ButtonTheme].
  final double minWidth;

  /// The vertical extent of the button.
  ///
  /// Defaults to the value from the current [ButtonTheme].
  final double height;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to the value from the current [ButtonTheme].
  final EdgeInsets padding;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  _RoundedButtonState createState() => new _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool _highlight = false;

  Brightness get _colorBrightness {
    return widget.colorBrightness ?? Theme.of(context).brightness;
  }

  Color get _textColor {
    if (widget.textColor != null)
      return widget.textColor;
    if (widget.enabled) {
      switch (widget.textTheme ?? ButtonTheme.of(context).textTheme) {
        case ButtonTextTheme.accent:
          return Theme.of(context).accentColor;
        case ButtonTextTheme.normal:
          switch (_colorBrightness) {
            case Brightness.light:
              return Colors.black87;
            case Brightness.dark:
              return Colors.white;
          }
      }
    } else {
      assert(_colorBrightness != null);
      switch (_colorBrightness) {
        case Brightness.light:
          return Colors.black26;
        case Brightness.dark:
          return Colors.white30;
      }
    }
    return null;
  }

  void _handleHighlightChanged(bool value) {
    setState(() {
      _highlight = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final Color textColor = _textColor;
    final TextStyle style = theme.textTheme.button.copyWith(color: textColor);
    final ButtonTheme buttonTheme = ButtonTheme.of(context);
    final double height = widget.height ?? buttonTheme.height;
    final double elevation = (_highlight ? widget.highlightElevation : widget.elevation) ?? 0.0;
    final bool hasColorOrElevation = (widget.color != null || elevation > 0);
    Widget contents = IconTheme.merge(
        data: new IconThemeData(
            color: textColor
        ),
        child: new InkWell(
            borderRadius: new BorderRadius.circular(height),
            highlightColor: widget.highlightColor ?? theme.highlightColor,
            splashColor: widget.splashColor ?? theme.splashColor,
            onTap: widget.onPressed,
            onHighlightChanged: _handleHighlightChanged,
            child: new Container(
                padding: widget.padding ?? ButtonTheme.of(context).padding,
                child: new Center(
                    widthFactor: 1.0,
                    child: widget.child
                )
            )
        )
    );
    if (hasColorOrElevation) {
      contents = new Material(
          color: widget.color,
          borderRadius: new BorderRadius.circular(height),
          elevation: elevation,
          textStyle: style,
          child: contents
      );
    } else {
      contents = new AnimatedDefaultTextStyle(
          style: style,
          duration: kThemeChangeDuration,
          child: contents
      );
    }
    return new ConstrainedBox(
        constraints: new BoxConstraints(
            minWidth: widget.minWidth ?? buttonTheme.minWidth,
            minHeight: height,
            maxHeight: height
        ),
        child: contents
    );
  }
}
