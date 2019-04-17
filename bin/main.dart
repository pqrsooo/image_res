import 'dart:io';

import 'package:image_res/image_res.dart';

/// A main entrypoint of a CLI tool
void main(List<String> args) async {
  const configPath = 'image_res.yaml';
  if (FileSystemEntity.typeSync(configPath) == FileSystemEntityType.notFound) {
    // `image_res.yaml` does not exist
    print(
        'There is no `image_res.yaml` in your project\'s root directory. Please consult https://github.com/pirsquareff/img_res for more information regarding the configuration.');
    exit(2);
  }

  var org = FlutterImgResolutionOrganizer.withConfigFile(configPath);

  int exitCode = 0;

  if (args.length > 0) {
    String command = args[0];
    if (command == 'run') {
      exitCode = org.run();
    } else if (command == 'watch') {
      exitCode = await org.watch();
    } else {
      print('`$command` is not a valid command.');
      exitCode = 2;
    }
  } else {
    exitCode = org.run();
  }

  exit(exitCode);
}
