# Daassets

A **Dart** package to automatically generate a class containing references to all assets in your project.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```yaml
dev_dependencies:
  daassets: ^1.3.2
```

## Example

#### Define your assets

In your **pubspec.yaml** file:

```yaml
flutter:

  assets:

    - assets/icon/            # imports all files in that directory
    - assets/icon/close.png   # imports that specific file
```

#### Generating Dart code

To generate the **Dart** file containing all assets, run the following command:

```bash
flutter pub pub run daassets:daassets.dart PUBSPEC_FILE_PATH OUTPUT_FILE_PATH
```

For example:

```bash
flutter pub pub run daassets:daassets.dart ./pubspec.yaml ./lib/assets.dart
```

#### Using generated code

The generated class contains static constants that you can use anywhere in your project.

```dart
Image.asset(Assets.ICON_CLOSE);
```