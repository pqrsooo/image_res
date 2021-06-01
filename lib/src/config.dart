import 'dart:io';

import 'package:yaml/yaml.dart';

class DefaultConfig {
  static const String ASSET_FOLDER_PATH = 'assets/images';

  static const List<String> FILE_EXTENSIONS = [
    '.jpg',
    '.png',
  ];

  static const String RESOLUTION_INDICATOR = '@{N}x';

  static const bool ALLOW_OVERWRITE = false;
}

class Config {
  late String assetFolderPath;
  late List<String> fileExtensions;
  late String resolutionIndicator;
  late bool allowOverwrite;

  String? startInd;
  String? endInd;
  late RegExp fileNameRegExp;

  static RegExp resIndRegExp = RegExp('(.*){N}(.*)');

  Config(
      {this.assetFolderPath = DefaultConfig.ASSET_FOLDER_PATH,
      this.fileExtensions = DefaultConfig.FILE_EXTENSIONS,
      this.resolutionIndicator = DefaultConfig.RESOLUTION_INDICATOR,
      this.allowOverwrite = DefaultConfig.ALLOW_OVERWRITE}) {
    _decomposeResolutionIndicator();
    _generateFileNameRegExp();
  }

  Config.fromFile(String filePath) {
    String yamlContent = File(filePath).readAsStringSync();
    YamlMap yamlMap = loadYaml(yamlContent);
    assetFolderPath =
        yamlMap['asset_folder_path'] ?? DefaultConfig.ASSET_FOLDER_PATH;
    if (yamlMap['file_extensions'] is YamlList) {
      fileExtensions = _getListFromYamlList(yamlMap['file_extensions']);
    } else {
      fileExtensions = DefaultConfig.FILE_EXTENSIONS;
    }
    resolutionIndicator =
        yamlMap['resolution_indicator'] ?? DefaultConfig.RESOLUTION_INDICATOR;
    allowOverwrite =
        yamlMap['allow_overwrite'] ?? DefaultConfig.ALLOW_OVERWRITE;

    _decomposeResolutionIndicator();
    _generateFileNameRegExp();
  }

  List<String> _getListFromYamlList(YamlList yamlList) {
    List<String> list = [];
    var _list = yamlList.map((el) => el.toString()).toList();
    list.addAll(_list);
    return list;
  }

  void _decomposeResolutionIndicator() {
    final resIndMatch = Config.resIndRegExp.firstMatch(resolutionIndicator);
    startInd = resIndMatch?.group(1);
    endInd = resIndMatch?.group(2);
  }

  void _generateFileNameRegExp() {
    fileNameRegExp = RegExp('(.*)($startInd(\\d*\\.*\\d*)$endInd)(.*)(\\..*)');
  }
}
