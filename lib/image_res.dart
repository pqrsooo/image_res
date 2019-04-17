library flutter_img_resolution_organizer;

import 'dart:io';
import 'dart:core';
import 'package:path/path.dart';

import 'src/config.dart';

class FlutterImgResolutionOrganizer {
  Config config;

  FlutterImgResolutionOrganizer(String configPath) {
    config = Config.fromFile(configPath);
  }

  int run() {
    int exitCode = 0;

    int nMovedFile = 0;
    List<FileSystemEntity> entities = _getFileEntitiesInDirectory(config.assetFolderPath, config.fileExtensions);
    for (var entity in entities) {
      nMovedFile += _moveFileToItsResolutionFolder(entity, config.fileNameRegExp);
    }
    print('$nMovedFile file(s) have been arranged.');

    return exitCode;
  }

  int _moveFileToItsResolutionFolder(FileSystemEntity entity, RegExp fileNameRegExp) {
    int nAffectedFile = 0;
    Match fileNameMatch = fileNameRegExp.firstMatch(basename(entity.path));
    if (fileNameMatch != null) {
      // Extract a filename and its resolution
      String fileNameWithExt = '${fileNameMatch.group(1)}${fileNameMatch.group(4)}${fileNameMatch.group(5)}';
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
        print('$toDirectory$fileNameWithExt has already existed. Try change the file name.');
      }
    }
    return nAffectedFile;
  }

  List<FileSystemEntity> _getFileEntitiesInDirectory(String directoryPath, List<String> fileExtensions) {
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