# Image Res
[![pub package](https://img.shields.io/pub/v/image_res.svg)](https://pub.dartlang.org/packages/image_res)

A command-line tool which automates a task of grouping image files into appropriate folders based on their resolution indicated in the file name. Refer to [`https://flutter.dev/docs/development/ui/assets-and-images#loading-images`](https://flutter.dev/docs/development/ui/assets-and-images#loading-images) for further information regarding how Flutter manages resolution-appropriate images. To put it another way, when you copy and paste your image assets in your Flutter project and run this plugin. It'll look into all images' filename and automatically move them to appropriate-resolution folders.

Now supports null-safety.

For example, if you place images in the asset folder as shown below: 

```
assets/
+-- images/
|   +-- icons/
|   |   +-- search.png
|   |   +-- search@2x.png
|   |   +-- search@3x.png
|   +-- logo.png
|   +-- logo@2x.png
|   +-- logo@3x.png
```

After running this plugin (with a configuration file in the project's root directory), the images whose filename includes a resolution indicator will be moved as follows:

```
assets/
+-- images/
|   +-- 2.0x/
|   |   +-- logo.png
|   +-- 3.0x/
|   |   +-- logo.png
|   +-- icons/
|   |   +-- 2.0x/
|   |   |   +-- search.png
|   |   +-- 3.0x/
|   |   |   +-- search.png
|   |   +-- search.png
|   +-- logo.png
```

## Getting Started
1. Install the `image_res` plugin by adding it in `pubspec.yaml` under `dev_dependencies` section and run `flutter packages get`
    ```yaml
    dev_dependencies: 
        image_res: ^0.3.0
    ```
2. Create a new configuration file called `image_res.yaml` in the project's root directory
    ```yaml
    # The organizer recursively looks into all files in the `asset_folder_path`. (relative to the project's root)
    asset_folder_path: assets/images/

    # The organizer only arranges files with their extension listed in the `file_extensions`.
    file_extensions:
        - .jpg
        - .png

    # The organizer uses `resolution_indicator` to extract a resolution's part from the filename.
    # The `resolution_indicator` must conform to the following pattern:
    #   '[start_token]{N}[end_token]' where
    #       - [start_token]: A token that indicates a starting point of the resolution's part.
    #       - [end_token]: A token that indicates an ending point of the resolution's part.
    #
    # Valid `resolution_indicator`s along with example filenames that they can detect are shown below.
    #   '@{N}x': logo@2x.png, logo@2.0x.png, @2.0xlogo.png
    #   '--{N}#': logo--2#.png, logo--2.0#.png, --2.0#logo.png
    resolution_indicator: '@{N}x'

    # If `allow_overwrite` is true when there is the same filename already existing in a target folder, the organizer will replace it.
    allow_overwrite: false

    ```
3. Run the plugin in the project's root directory. See [Available CLI Commands](#available-cli-commands)
    ```sh
    flutter packages pub run image_res:main <command>
    ```

**Note that** this plugin can be installed globally by `flutter packages pub global activate image_res`. Instead of typing a long command shown above, you can run it by just `imgres`.

If you encounter an issue indicating `dart: command not found`, please install Dart separately first and try running again.

## Available CLI Commands

| Commands | Description |
| -------- | ----------- |
| `[blank]` | Run this plugin once |
| `run` | Run this plugin once |
| `watch` | Run this plugin and watch for changes |

### Usage
- If the plugin was installed globally, run it by:
    ```sh
    imgres <command>
    ```
- If the plugin was installed locally in a Flutter project, run it by:
    ```sh
    flutter packages pub run image_res:main <command>
    ```