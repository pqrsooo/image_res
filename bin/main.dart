import 'dart:io';

import 'package:image_res/image_res.dart';

void main(List<String> args) {
  const configPath = 'image_res_config.yaml';
  if (FileSystemEntity.typeSync(configPath) == FileSystemEntityType.notFound) {
    // `image_res_config.yaml` does not exist
    print('There is no `image_res_config.yaml` in your project\'s root directory. Please consult https://github.com/pirsquareff/flutter_img_resolution_organizer for more information regarding the configuration.');
    exit(2);
  }

  var org = FlutterImgResolutionOrganizer(configPath);
  int exitCode = org.run();

  exit(exitCode);
}