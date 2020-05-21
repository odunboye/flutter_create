import 'dart:io';

import 'package:rename/file_repository.dart';
import 'package:path/path.dart' as p;

extension MyFileRepositry on FileRepository {
  static String pubspecPath = 'pubspec.yaml';

  void hello() {
    print('hello from extension');
  }

  Future<void> myChangeIosAppName(String appName) async {
    try {
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
      await writeFile(
        filePath: p.join(
          appName,
          iosInfoPlistPath,
        ),
        content: contentLineByLine.join('\n'),
      );
      print('IOS appname changed successfully to : $appName');
    } catch(e){
      print('Error changing iOS appname - iOS folder possibly not there');
    }
  }

  Future<void> myChangeMacOsAppName(String appName) async {
    try {
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
      await writeFile(
        filePath: p.join(
          appName,
          macosAppInfoxprojPath,
        ),
        content: contentLineByLine.join('\n'),
      );
      print('MacOS appname changed successfully to : $appName');
    }catch(e){
      print('Error changing macOS appname - MacOS folder possibly not there');
    }
  }

  Future<void> myChangeAndroidAppName(String appName) async {
    try {
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
      await writeFile(
        filePath: p.join(
          appName,
          androidManifestPath,
        ),
        content: contentLineByLine.join('\n'),
      );
      print('Android appname changed successfully to : $appName');
    } catch (e){
      print('Error changing Android appname - Anroid folder possibly not there');
    }
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
