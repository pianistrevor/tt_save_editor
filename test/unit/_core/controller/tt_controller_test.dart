import 'dart:typed_data';
import 'package:test/test.dart';

import '../test_data.dart';

void main() {
  group('Save file controller', () {
    late TTTestSaveFile saveFile;
    late TTTestSaveFileController controller;
    setUp(() {
      var bytes = Uint8List.fromList(kTestFileBytes);
      saveFile = TTTestSaveFile.fromBytes(bytes, endian: Endian.little);
      controller = TTTestSaveFileController(saveFile: saveFile);
    });

    test('Controller has correct structure', () {
      expect(controller.saveData, same(controller));
      expect(controller.saveFile, same(saveFile));
    });

    test('Correct functionality of the checksum controller', () {
      expect(controller.checksum, equals(0xFF0E0D0C)); // Value from bytes, not correct
      expect(controller.checksumController.isDirty, isFalse);
      // Sum of all 4 byte values, no truncation
      expect(controller.calculateChecksum(), equals(0x15920F0C));
      controller.recalculateChecksum();
      expect(controller.checksum, equals(0x15920F0C));
      expect(controller.checksumController.isDirty, isTrue);
      controller.saveChanges();
      expect(controller.checksum, equals(0x15920F0C));
      expect(controller.checksumController.isDirty, isFalse);
    });
  });

  group('Composite controller', () {
    late TTTestSaveFileController saveFileController;
    late TTTestCompositeController controller;
    setUp(() {
      var bytes = Uint8List.fromList(kTestFileBytes);
      var saveFile = TTTestSaveFile.fromBytes(bytes, endian: Endian.little);
      saveFileController = TTTestSaveFileController(saveFile: saveFile);
      controller = TTTestCompositeController(parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
    });
  });
}
