# Image Res

A command-line tool which simplifies the task of placing the image's files into appropriate folders based on their resolution. Refer to `https://flutter.dev/docs/development/ui/assets-and-images#loading-images` for further information regarding how Flutter manages resolution-appropriate images. To put it another way, when you place your image assets in a Flutter project and run this plugin. It'll look into all images' filename and automatically move them to their appropriate-resolution folder.

For example, if you place images in the asset folder as shown below: 

```
asset/
+-- images/
|   +-- icons/
|   |   +-- search.png
|   |   +-- search@2x.png
|   |   +-- searcg@2x.png
|   +-- logo.png
|   +-- logo@2x.png
|   +-- logo@3x.png
```

After running this plugin (with a configuration file in the project's root directory), the images whose filename includes a resolution indicator will be moved as follows:

```
asset/
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
    image_res: ^0.1.0
    ```
2. Create a new configuration file called `image_res.yaml`
    ```yaml
    # The organizer recursively looks into all files in the `asset_folder_path`. (relative to the project's root)
    asset_folder_path: assets/images/

    # The organizer only arranges files with its extension in the `file_extensions` list.
    file_extensions:
        - .jpg
        - .png

    # The organizer uses `resolution_indicator` to extract a resolution's part from the filename.
    # The `resolution_indicator` must conform to the following pattern:
    #   '[start_token]{N}[end_token]' where
    #       - [start_token]: A token that indicates a starting point of the resolution's part.
    #       - [end_token]: A token that indicates an ending point of the resolution's part.
    #
    # Valid `resolution_indicator`s along with example filenames that it can detect are shown below.
    #   '@{N}x': logo@2x.png, logo@2.0x.png, @2.0xlogo.png
    #   '--{N}#': logo--2#.png, logo--2.0#.png, --2.0#logo.png
    resolution_indicator: '@{N}x'

    ```
3. Run the plugin in the project's root directory
    ```
    flutter packages pub run image_res:main
    ```

**Note that** this plugin can be installed globally by `flutter pub global activate image_res`. Instead of typing a long command shown above, you can run it by just `imgres`.

If you encounters an issue indicating `dart: command not found`, please install Dart separately first and try running again.