#!/usr/bin/env dart
library daassets;

import 'dart:io';
import 'package:yaml/yaml.dart';

Future<void> main(List<String> args) async {
  final File input = File(args[0]);
  final File output = File(args[1]);

  final String content = await input.readAsString();
  final dynamic yaml = loadYaml(content);

  final YamlList assets = yaml['flutter']['assets'];
  final List<File> files = getFiles(input, assets);

  generateClass(files, output);
}

List<File> getFiles(File input, YamlList assets) {
  final List<File> list = <File>[];

  for (dynamic asset in assets) {
    final String path = '${input.parent.path}${Platform.pathSeparator}$asset';

    final File file = File(path);
    final Directory directory = Directory(path);

    if (file.existsSync() && !fileExist(list, file)) {
      list.add(file);
    } else if (directory.existsSync()) {
      final List<FileSystemEntity> entries =
          directory.listSync(recursive: true);

      for (FileSystemEntity entry in entries) {
        final File newFile = File(entry.path);

        if (newFile.existsSync() && !fileExist(list, newFile)) {
          list.add(newFile);
        }
      }
    }
  }

  return list;
}

bool fileExist(List<File> list, File file) =>
    list.where((File f) => f.path == file.path).isNotEmpty;

void generateClass(List<File> files, File output) {
  final SourceFile source = SourceFile(output);
  source.clear();

  source.write('class Assets {\n');

  for (File file in files) {
    source
        .write("\tstatic const String ${assetName(file)} = '${file.path}';\n");
  }

  source.write('}\n');
}

String assetName(File file) {
  String name = '';
  final List<String> segments = file.uri.pathSegments;

  for (int i = 1; i < (segments.length - 1); i++) {
    if (name.isNotEmpty) {
      name += '_';
    }

    name += segments[i];
  }

  final String fileName = segments[segments.length - 1];
  final List<String> fileNameParts = fileName.split('.');

  if (name.isNotEmpty) {
    name += '_';
  }

  name += fileNameParts[0];

  return name.toUpperCase();
}

class SourceFile {
  final File file;

  SourceFile(this.file);

  void clear() {
    file.writeAsStringSync('');
  }

  void write(String content) {
    file.writeAsStringSync(content, mode: FileMode.append);
  }
}
