import 'dart:io';

import 'package:flutter_img_resolution_organizer/flutter_img_resolution_organizer.dart';

void main(List<String> args) {
  const configPath = 'firconfig.yaml';
  if (FileSystemEntity.typeSync(configPath) == FileSystemEntityType.notFound) {
    // `firconfig.yaml` does not exist
    print('`firconfig.yaml` does not exist. Please consult https://github.com/pirsquareff for more information regarding the configuration.');
    exit(2);
  }

  var org = FlutterImgResolutionOrganizer(configPath);
  int exitCode = org.run();

  exit(exitCode);
}