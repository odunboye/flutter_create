import 'dart:io';

import 'package:rename/file_repository.dart';
import 'package:path/path.dart' as p;

extension MyFileRepositry on FileRepository {
  static String pubspecPath = 'pubspec.yaml';

  void hello() {
    print('hello from extension');
  }

  Future<File> myChangeIosAppName(String appName) async {
    List contentLineByLine = await readFileAsLineByline(
        filePath: p.join(
      appName,
      iosInfoPlistPath,
    ));
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('<key>CFBundleName</key>')) {
        contentLineByLine[i + 1] = '\t<string>${appName}</string>\r';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: p.join(
        appName,
        iosInfoPlistPath,
      ),
      content: contentLineByLine.join('\n'),
    );
    print('IOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File> myChangeMacOsAppName(String appName) async {
    List contentLineByLine = await readFileAsLineByline(
        filePath: p.join(
      appName,
      macosAppInfoxprojPath,
    ));
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_NAME')) {
        contentLineByLine[i] = 'PRODUCT_NAME = $appName;';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: p.join(
        appName,
        macosAppInfoxprojPath,
      ),
      content: contentLineByLine.join('\n'),
    );
    print('MacOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File> myChangeAndroidAppName(String appName) async {
    List contentLineByLine = await readFileAsLineByline(
      filePath: p.join(
        appName,
        androidManifestPath,
      ),
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('android:label')) {
        contentLineByLine[i] = '        android:label=\"${appName}\"';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: p.join(
        appName,
        androidManifestPath,
      ),
      content: contentLineByLine.join('\n'),
    );
    print('Android appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File> changeImportName(
      String appName, String filePath, String oldAppName) async {
    List contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    var oldApp = oldAppName.trim();
    var newApp = appName.trim();
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].indexOf(oldApp) > 0) {
        contentLineByLine[i] =
            contentLineByLine[i].replaceFirst(oldApp, '$newApp');
      }
    }
    var writtenFile = await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    print('Import $oldApp changed successfully to : $newApp');
    return writtenFile;
  }

  // ignore: missing_return
  Future<String> getCurrentPubSpecName(String dirPath) async {
    List contentLineByLine = await readFileAsLineByline(
      filePath: p.join(dirPath, pubspecPath),
    );

    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('name:')) {
        return (contentLineByLine[i] as String).split(':')[1];
      }
    }
  }
}
