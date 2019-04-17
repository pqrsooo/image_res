library image_res;

import 'dart:io';
import 'dart:core';
import 'package:path/path.dart';

import 'src/config.dart';

class FlutterImgResolutionOrganizer {
  /// A configulation instance
  Config config;

  /// A main constructor
  FlutterImgResolutionOrganizer(String configPath) {
    config = Config.fromFile(configPath);
  }

  /// Organise image's file according to the setting in the config instance
  int run() {
    int exitCode = 0;

    int nMovedFile = 0;
    List<FileSystemEntity> entities = _getFileEntitiesInDirectory(
        config.assetFolderPath, config.fileExtensions);
    for (var entity in entities) {
      nMovedFile +=
          _moveFileToItsResolutionFolder(entity, config.fileNameRegExp);
    }
    print('$nMovedFile file(s) have been arranged.');

    return exitCode;
  }

  /// Move a file to the target folder according to its resolution indicator
  int _moveFileToItsResolutionFolder(
      FileSystemEntity entity, RegExp fileNameRegExp) {
    int nAffectedFile = 0;
    Match fileNameMatch = fileNameRegExp.firstMatch(basename(entity.path));
    if (fileNameMatch != null) {
      // Extract a filename and its resolution
      String fileNameWithExt =
          '${fileNameMatch.group(1)}${fileNameMatch.group(4)}${fileNameMatch.group(5)}';
      double resolution = double.parse('${fileNameMatch.group(3)}');

      String resolutionDirectoryName = '${resolution.toStringAsFixed(1)}x';
      String toDirectory = '${entity.parent.path}/$resolutionDirectoryName/';
      Directory(toDirectory).createSync(recursive: true);
      String toPath = '$toDirectory$fileNameWithExt';

      if (FileSystemEntity.typeSync(toPath) == FileSystemEntityType.notFound) {
        entity.renameSync('$toDirectory$fileNameWithExt');
        print('Moved ${entity.path} -> $toDirectory$fileNameWithExt');
        nAffectedFile = 1;
      } else {
        print(
            '$toDirectory$fileNameWithExt has already existed. Try change the file name.');
      }
    }
    return nAffectedFile;
  }

  /// Return a list of all files in the specific directory filtered by file extensions
  List<FileSystemEntity> _getFileEntitiesInDirectory(
      String directoryPath, List<String> fileExtensions) {
    var dir = Directory(directoryPath);
    var fileExtensionsSet = Set.from(fileExtensions);
    List entities = dir
        .listSync(recursive: true, followLinks: false)
        .where((el) =>
            el is FileSystemEntity &&
            el is File &&
            fileExtensionsSet.contains(extension(el.path)))
        .toList();
    return entities;
  }
}
