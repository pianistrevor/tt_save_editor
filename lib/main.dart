import 'package:flutter/material.dart';
import 'package:tt_save_editor/app_config.dart';
import 'package:tt_save_editor/view/app_content.dart';

void main() async {
  // Setup
  await setupApp();
  runApp(const TTSaveFileEditorApp());
}

Future<void> setupApp() async {
  await AppConfig.initialize();
}

class TTSaveFileEditorApp extends StatelessWidget {
  const TTSaveFileEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTSaveFileEditor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppContent(),
    );
  }
}
