import 'package:test/test.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_misc_section.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_save_file.dart';

void main() async {
  late LSW1SaveFile saveFile;
  late LSW1MiscSectionController controller;

  setUp(() {
    saveFile = LSW1SaveFile.blank();
    var saveFileController = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    controller = saveFileController.misc;
  });

  test('Controller reads and writes correct values', () {
    expect(controller.isDirty, isFalse);
    controller.setSuperkitCount(17);
    expect(controller.isDirty, isTrue);
    controller.saveChanges();
    expect(controller.superkitCount, equals(17));
    expect(controller.isDirty, isFalse);
    controller.enableEpisode2and3Zoom();
    expect(controller.isDirty, isFalse);
    controller.disableAutoSave();
    controller.disableMusic();
    controller.enableSurroundSound();
    expect(controller.isDirty, isTrue);
    expect(controller.autoSaveController.isDirty, isTrue);
    expect(controller.musicController.isDirty, isTrue);
    expect(controller.surroundSoundController.isDirty, isTrue);
    controller.autoSaveController.saveChanges();
    expect(controller.isDirty, isTrue);
    expect(controller.autoSaveController.isDirty, isFalse);
    expect(controller.musicController.isDirty, isTrue);
    expect(controller.surroundSoundController.isDirty, isTrue);
    controller.saveChanges();
    expect(controller.isDirty, isFalse);
    expect(controller.autoSaveEnabled, isFalse);
    expect(controller.musicEnabled, isFalse);
    expect(controller.surroundSoundEnabled, isTrue);
  });
}
