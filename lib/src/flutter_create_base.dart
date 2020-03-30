import 'package:path/path.dart' as p;
import 'package:rename/file_repository.dart';
import 'file_repository_extension.dart';
import 'dart:io';

enum Platform {
  android,
  ios,
  macOS,
}

class FlutterCreate {
  bool get isAwesome => true;
  FileRepository fileRepository = FileRepository();

  void create({List<String> args, String appName}) async {
    args.insert(0, 'clone');
    await Process.run('git', args,
            workingDirectory: p.current, runInShell: true)
        .then((result) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    });
    await changeAppName(
        appName: appName, platforms: [Platform.android, Platform.ios]);
  }

  void changeFilesImports(String appName, String oldAppName) {
    var dir = Directory(appName);
    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    dir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      if (entity.path.endsWith('dart') || entity.path.endsWith('.yaml')) {
        fileRepository.changeImportName(appName, entity.path, oldAppName);
      }
    });
  }

  Future<String> getPubSpecName(String path) async {
    return fileRepository.getCurrentPubSpecName(path);
  }

  // change rename.changeAppName
  Future changeAppName({String appName, Iterable<Platform> platforms}) async {
    var oldName = await fileRepository.getCurrentPubSpecName(appName);
    if (platforms.isEmpty || platforms.contains(Platform.ios)) {
      await fileRepository.myChangeIosAppName(appName);
    }
    if (platforms.isEmpty || platforms.contains(Platform.macOS)) {
      await fileRepository.myChangeMacOsAppName(appName);
    }
    if (platforms.isEmpty || platforms.contains(Platform.android)) {
      await fileRepository.myChangeAndroidAppName(appName);
    }
    changeFilesImports(appName, oldName);
  }
}
