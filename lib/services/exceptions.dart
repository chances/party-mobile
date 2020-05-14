import 'package:flutter/material.dart';

class NestedException implements Exception {
  String message;
  Exception innerException;

  NestedException(this.message, [this.innerException]);

  String toString() => message;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> innerExceptionMessage = {
      'message': innerException.toString()
    };
    if (innerException is NestedException) {
      var ex = innerException as NestedException;
      innerExceptionMessage = ex.toJson();
    }

    return {'message': message, 'inner_exception': innerExceptionMessage};
  }
}

Future<Null> showErrorDialog(BuildContext context, String title,
    [Exception exception, String message = 'Unknown error:']) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(message),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: exception != null ? Text(exception.toString()) : null,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit Feedback'),
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Sentry feedback form, mailto: link, or something?
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
