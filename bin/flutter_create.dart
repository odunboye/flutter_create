import 'package:args/args.dart';
import 'package:flutter_create/flutter_create.dart';

const android = 'android';
const macOS = 'macOS';
const ios = 'ios';

const target = 'target';
const appname = 'appname';
const url = 'url';
const bundleId = 'bundleId';
const launcherIcon = 'launcherIcon';
const help = 'help';

final argParser = ArgParser()
  ..addOption(appname, abbr: 'a', help: 'Sets the name of the app.')
  ..addOption(url, abbr: 'u', help: 'Sets the template repository url.')
  ..addFlag(help, abbr: 'h', help: 'Shows help.', negatable: false);

void main(List<String> arguments) async {
  try {
    final results = argParser.parse(arguments);
    if (results[help] || results.arguments.isEmpty) {
      print(argParser.usage);
      return;
    }

    if (results[appname] != null) {
      var sourceCreator = FlutterCreate();
      sourceCreator.create(
        args: [
          results[url], //url
          results[appname], //'my_donation'
        ],
        appName: results[appname],
      );
    }
  } on FormatException catch (e) {
    print(e.message);
    print('');
    print(argParser.usage);
  }
}
