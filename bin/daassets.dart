#!/usr/bin/env dart

library daassets;

import 'dart:io';
import 'package:yaml/yaml.dart';

/// Entry point.
Future<void> main(List<String> args) async {
  final File input = File(args[0]);
  final File output = File(args[1]);

  final String content = await input.readAsString();
  final dynamic yaml = loadYaml(content);

  final YamlList assets = yaml['flutter']['assets'];
  final List<File> files = _getFiles(input, assets);

  _generateClass(files, output);
}

List<File> _getFiles(File input, YamlList assets) {
  final List<File> list = <File>[];

  for (final dynamic asset in assets) {
    final String path = '${input.parent.path}${Platform.pathSeparator}$asset';

    final File file = File(path);
    final Directory directory = Directory(path);

    if (file.existsSync() && !_fileExist(list, file) && !_shouldIgnore(file)) {
      list.add(file);
    } else if (directory.existsSync()) {
      final List<FileSystemEntity> entries =
          directory.listSync(recursive: true);

      for (final FileSystemEntity entry in entries) {
        final File newFile = File(entry.path);

        if (newFile.existsSync() &&
            !_fileExist(list, newFile) &&
            !_shouldIgnore(newFile)) {
          list.add(newFile);
        }
      }
    }
  }

  return list;
}

bool _fileExist(List<File> list, File file) =>
    list.where((File f) => f.path == file.path).isNotEmpty;

bool _shouldIgnore(File file) => file.path.endsWith('DS_Store');

void _generateClass(List<File> files, File output) {
  final SourceFile source = SourceFile(output);
  source.clear();

  source.write('class Assets {\n');

  for (final File file in files) {
    final String realPath = file.path.substring(file.path.indexOf('assets/'));
    source
        .write("\tstatic const String ${_assetName(file)} = './$realPath';\n");
  }

  source.write('}\n');
}

String _assetName(File file) {
  String name = '';
  bool started = false;
  final List<String> segments = file.uri.pathSegments;

  for (int i = 0; i < (segments.length - 1); i++) {
    if (name.isNotEmpty) {
      name += '_';
    }

    if (started) {
      name += segments[i];
    }

    if (segments[i].toLowerCase() == 'assets') {
      started = true;
    }
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
