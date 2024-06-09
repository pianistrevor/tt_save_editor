import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_save_file.dart';

const kFilePathLSW1Save = 'assets/blank_saves/lsw1.bin';

void main() async {
  final saveFileFromAssets = LSW1SaveFile(kFilePathLSW1Save);

  group('Blank save file comparisons', () {
    late LSW1SaveFile saveFile;
    late LSW1SaveFileController controller;

    setUp(() {
      saveFile = LSW1SaveFile.blank();
      controller = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    });

    test('Blank save file matches expected file from bytes', () {
      expect(listEquals(saveFile.byteList, saveFileFromAssets.byteList), equals(true));
    });

    test('Blank save file controller answers correct misc values', () {
      final misc = controller.misc;
      expect(misc.superkitCount, isZero);
      expect(misc.episode2and3ZoomEnabled, isTrue); // But not showing yet
      expect(misc.autoSaveEnabled, isTrue);
      expect(misc.surroundSoundEnabled, isFalse);
      expect(misc.sfxVolume, equals(8));
      expect(misc.musicVolume, equals(6));
      expect(misc.masterVolume, equals(10));
      expect(misc.musicEnabled, isTrue);
      expect(misc.reverseUpDownEnabled, isFalse);
    });

    test('Blank save file controller answers correct other values', () {
      expect(controller.levels.negotiations.unlocked, isTrue);
      expect(controller.shop.characterUnlocked('quiGonJinn'), isTrue);
      expect(controller.shop.characterUnlocked('obiWanKenobi'), isTrue);
      expect(controller.checksum, equals(0x06080624));
    });
  });

  group('Testing API of the save file controller', () {
    late LSW1SaveFile saveFile;
    late LSW1SaveFileController controller;

    setUp(() {
      saveFile = LSW1SaveFile.blank();
      controller = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    });

    test('Checksum controller calculates correctly', () {
      expect(controller.checksum, equals(0x06080624)); // Value from bytes, not correct
      expect(controller.checksumController.isDirty, isFalse);
      saveFile.setUint8(3, 0xFF); // Should subtract 1 from the highest byte of the checksum
      // Sum of all 4 byte values, no truncation
      expect(controller.calculateChecksum(), equals(0x05080624));
      controller.recalculateChecksum();
      expect(controller.checksum, equals(0x05080624));
      expect(controller.checksumController.isDirty, isTrue);
      controller.saveChanges();
      expect(controller.checksum, equals(0x05080624));
      expect(controller.checksumController.isDirty, isFalse);
    });

    test('Stud count controller correctly sets positive value', () {
      expect(controller.studCount, isZero);
      controller.setStudCount(250);
      expect(controller.studCount, equals(250));
      expect(controller.isDirty, isTrue);
      expect(controller.studCountController.isDirty, isTrue);
      controller.saveChanges();
      expect(controller.studCount, equals(250));
      expect(controller.isDirty, isFalse);
      expect(controller.checksum, equals(0x0608071E)); // +0xFA
    });

    test('Stud count controller correctly sets negative value', () {
      controller.setStudCount(-250);
      expect(controller.studCount, equals(-250));
      expect(controller.isDirty, isTrue);
      expect(controller.studCountController.isDirty, isTrue);
      controller.saveChanges();
      expect(controller.studCount, equals(-250));
      expect(controller.isDirty, isFalse);
      expect(controller.checksum, equals(0x0608052A)); // -0xFA
    });

    test('Hints shown controller correctly shows values', () {
      expect(controller.hintsController.bitLength, equals(27));
      expect(controller.hintShown(0), isFalse);
      expect(controller.hintShown(26), isFalse);
      controller.setHintShown(0);
      controller.setHintShown(26);
      expect(controller.isDirty, isTrue);
      expect(controller.hintShown(0), isTrue);
      expect(controller.hintShown(26), isTrue);
      controller.unsetHintShown(26);
      expect(controller.isDirty, isTrue);
      expect(controller.hintShown(0), isTrue);
      expect(controller.hintShown(26), isFalse);
    });
  });
}
