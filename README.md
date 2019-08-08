# Daassets

A **Flutter** package to automatically generate a class containing references to all assets in your project.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```yaml
dev_dependencies:
  daassets: ^1.0.0
```

## Example

### Define your assets

Create a folder to store all the localizations in **json** format. The name of each file should match the locale that is representing. For example:

```yaml
flutter:

  assets:

    - assets/icon/ # imports all files in that directory
    - assets/icon/close.png # import that specific file
```

### Generating Dart code

To generate the **Dart** file containing all the assets, run the following command:

```bash
flutter pub pub run daassets:daassets.dart PUBSPEC_FILE_PATH OUTPUT_FILE_PATH
```

For example:

```bash
flutter pub pub run daassets:daassets.dart ./example/pubspec.yaml ./example/assets.dart
```

### Using generated code

```dart
Image.asset(Assets.ICON_CLOSE);
```