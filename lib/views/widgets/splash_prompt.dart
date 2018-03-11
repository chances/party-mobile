import 'package:flutter/material.dart';

class SplashPrompt extends StatelessWidget {
  final String title;
  final List<String> paragraphs;

  SplashPrompt(this.title, this.paragraphs);

  @override
  Widget build(BuildContext context) {
    var prompts = <Widget>[
      new Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: new Text(title, style: Theme.of(context).textTheme.headline),
      )
    ];

    prompts.addAll(
      paragraphs.map((paragraph) => _paragraph(context, paragraph))
    );

    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: prompts
      ),
    );
  }

  Widget _paragraph(BuildContext context, String prose) {
    return new Padding(
      padding: new EdgeInsets.only(top: 4.0),
      child: new Text(
        prose,
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }
}
