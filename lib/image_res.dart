library image_res;

import 'dart:io';
import 'dart:core';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import 'src/config.dart';

class FlutterImgResolutionOrganizer {
  /// A configulation instance
  Config config;

  /// A main constructor with a default configuration
  FlutterImgResolutionOrganizer() {
    config = Config();
  }

  /// A named constructor that creates an instance with a config
  FlutterImgResolutionOrganizer.withConfig(
      {var assetFolderPath = DefaultConfig.ASSET_FOLDER_PATH,
      var fileExtensions = DefaultConfig.FILE_EXTENSIONS,
      var resolutionIndicator = DefaultConfig.RESOLUTION_INDICATOR}) {
    config = Config(
      assetFolderPath: assetFolderPath,
      fileExtensions: fileExtensions,
      resolutionIndicator: resolutionIndicator,
    );
  }

  /// A named constructor that creates an instance with a configPath provided
  FlutterImgResolutionOrganizer.withConfigFile(String configPath) {
    config = Config.fromFile(configPath);
  }

  /// [For CLI] Organise image's file according to the setting in the config instance
  int run() {
    int exitCode = 0;

    int nMovedFile = 0;
    List<FileSystemEntity> entities = _getFileEntitiesInDirectory(
        config.assetFolderPath, config.fileExtensions);
    for (var entity in entities) {
      nMovedFile += moveFileToItsResolutionFolder(entity);
    }
    print('$nMovedFile file(s) have been arranged.');

    return exitCode;
  }

  /// [For CLI] Watch and organise image's file according to the setting in the config instance
  Future<int> watch() async {
    int exitCode = 0;

    run();
    print('Watching...');

    var watcher = DirectoryWatcher(p.absolute(config.assetFolderPath));
    await for (var event in watcher.events) {
      if (event.type == ChangeType.ADD || event.type == ChangeType.MODIFY) {
        var f = File(event.path);
        if (_shouldMoveThisFile(f)) {
          moveFileToItsResolutionFolder(f);
        }
      }
    }

    return exitCode;
  }

  /// Move a file to the target folder according to its resolution indicator
  int moveFileToItsResolutionFolder(FileSystemEntity entity) {
    var fileNameRegExp = config.fileNameRegExp;
    int nAffectedFile = 0;
    Match fileNameMatch = fileNameRegExp.firstMatch(p.basename(entity.path));
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
            fileExtensionsSet.contains(p.extension(el.path)))
        .toList();
    return entities;
  }

  /// Return true if this file should be organised
  bool _shouldMoveThisFile(File file) {
    var fileExtensionsSet = Set.from(config.fileExtensions);
    return fileExtensionsSet.contains(p.extension(file.path));
  }
}
