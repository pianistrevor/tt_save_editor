import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

const configFileName = 'config.json';

class AppConfig {
  AppConfig._fromExistingJson(
      {required this.directoryPath, required this.configFile, required Map<String, dynamic> json})
      : savedPaths = (json['savedPaths'] as List<dynamic>).map((e) => e as String).toList();
  AppConfig._({required this.directoryPath, required this.configFile}) : savedPaths = [];
  factory AppConfig() => _instance;
  static late final AppConfig _instance;

  static Future<void> initialize() async {
    var directoryPath = await _ensureAppDataDirectoryExists();
    var configFile = File('$directoryPath/$configFileName');
    Map<String, dynamic> json = {};
    if (await configFile.exists()) {
      json = jsonDecode(configFile.readAsStringSync());
      _instance = AppConfig._fromExistingJson(
        directoryPath: directoryPath,
        configFile: configFile,
        json: json,
      );
      return;
    }
    _instance = AppConfig._(directoryPath: directoryPath, configFile: configFile);
  }

  void addSavedPath(String path) => savedPaths.add(path);
  void removeSavedPath(String path) => savedPaths.removeWhere((v) => v == path);

  Future<void> write() async {
    var json = toJson();
    await configFile.writeAsString(json);
  }

  String toJson() => jsonEncode({
        'savedPaths': savedPaths,
      });

  static Future<String> _ensureAppDataDirectoryExists() async {
    var directory = await getApplicationCacheDirectory();
    var directoryPath = directory.path;
    debugPrint('App data stored in: $directoryPath');

    if (!await directory.exists()) {
      await directory.create();
    }
    return directoryPath;
  }

  final List<String> savedPaths;

  final String directoryPath;

  final File configFile;
}
