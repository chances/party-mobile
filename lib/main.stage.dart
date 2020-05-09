import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  await DotEnv().load('env_stage.env');

  runApp(new PartyApp());
}
