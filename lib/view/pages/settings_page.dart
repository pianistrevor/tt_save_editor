import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tt_save_editor/app_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _buildSavedPathsTableRowsFrom(AppConfig().savedPaths);
  }

  var savedPathsTableRows = <String, TableRow>{};

  void _buildSavedPathsTableRowsFrom(List<String> paths) {
    for (var path in paths) {
      _buildSavedPathTableRow(path);
    }
  }

  void _buildSavedPathTableRow(String path) {
    savedPathsTableRows[path] = TableRow(
      children: [
        IconButton.filled(
          icon: const Icon(Icons.close),
          onPressed: () => _savedPathRemoved(path),
        ),
        Text(path),
      ],
    );
  }

  void _savedPathRemoved(String path) {
    setState(() {
      AppConfig()
        ..removeSavedPath(path)
        ..write();
      savedPathsTableRows.remove(path);
    });
  }

  void _savedPathPicked(String path) {
    setState(() {
      AppConfig()
        ..addSavedPath(path)
        ..write();
      _buildSavedPathTableRow(path);
    });
  }

  void _pickDirectoryDialog() async {
    var result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select "Lego Star Wars: The Video Game" installation directory',
      lockParentWindow: true,
    );
    if (result != null) {
      _savedPathPicked(result);
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: savedPathsTableRows.values.toList(),
            ),
            FilledButton.icon(
                icon: const Icon(Icons.add),
                onPressed: _pickDirectoryDialog,
                label: const Text('Add new path')),
          ],
        ),
      );
}
