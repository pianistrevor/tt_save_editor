import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';

import '../test_data.dart';

void main() {
  late TTTestSaveFile saveFile;
  late TTTestSaveFileController saveFileController;

  setUpSaveFileAndSaveFileController() {
    var bytes = Uint8List.fromList(kTestFileBytes);
    saveFile = TTTestSaveFile.fromBytes(bytes, endian: Endian.little);
    saveFileController = TTTestSaveFileController(saveFile: saveFile);
  }

  group('TTUint8Controller', () {
    late TTUint8Controller controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTUint8Controller(0x08, parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals(8));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with initial value', () {
      controller = TTUint8Controller(0x00, parent: saveFileController, initialValue: 0x20);
      expect(controller.value, equals(0x20));
      expect(controller.isDirty, isTrue);
    });

    test('Controller with invalid initial value', () {
      expect(() => TTUint8Controller(0x00, parent: saveFileController, initialValue: -257),
          throwsA(isA<AssertionError>()));
      expect(() => TTUint8Controller(0x00, parent: saveFileController, initialValue: 256),
          throwsA(isA<AssertionError>()));
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x12;
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.value = 0x13;
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.value = 0x14;
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint8(0x08), equals(0x14));
      expect(controller.value, equals(0x14));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.value = 0x14;
      controller.cancelChanges();
      expect(saveFile.getUint8(0x08), equals(8));
      expect(controller.value, equals(8));
      expect(controller.isDirty, isFalse);
    });
  });

  group('TTInt32Controller', () {
    late TTInt32Controller controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTInt32Controller(0x0C, parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals(-15856372));
      expect(controller.isDirty, isFalse);
    });

    test('Controller reads correct value, big endian', () {
      saveFile.endian = Endian.big;
      controller.cancelChanges();
      expect(controller.value, equals(0x0C0D0EFF));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with initial value', () {
      controller = TTInt32Controller(0x00, parent: saveFileController, initialValue: 2);
      expect(controller.value, equals(2));
      expect(controller.isDirty, isTrue);
    });

    test('Controller with invalid initial value', () {
      expect(() => TTInt32Controller(0x00, parent: saveFileController, initialValue: -0x1FFFFFFFF),
          throwsA(isA<AssertionError>()));
      expect(() => TTInt32Controller(0x00, parent: saveFileController, initialValue: 0x1FFFFFFFF),
          throwsA(isA<AssertionError>()));
    });

    test('Controller with initial value, big endian', () {
      saveFile.endian = Endian.big;
      controller = TTInt32Controller(0x0C, parent: saveFileController, initialValue: 0x0C0D0EFF);
      expect(controller.value, equals(0x0C0D0EFF));
      expect(controller.isDirty, isFalse);
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x12;
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.value = 0x13;
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.value = -14803684; // 0xFF1E1D1C as Int32
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint32(0x0C), equals(0xFF1E1D1C));
      expect(controller.value, equals(-14803684));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.value = 0x1C1D1EFF;
      controller.cancelChanges();
      expect(saveFile.getInt32(0x0C), equals(-15856372));
      expect(controller.value, equals(-15856372));
      expect(controller.isDirty, isFalse);
    });
  });

  group('TTUint32Controller', () {
    late TTUint32Controller controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTUint32Controller(0x0C, parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals(0xFF0E0D0C));
      expect(controller.isDirty, isFalse);
    });

    test('Controller reads correct value, big endian', () {
      saveFile.endian = Endian.big;
      controller.cancelChanges();
      expect(controller.value, equals(0x0C0D0EFF));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with initial value', () {
      controller = TTUint32Controller(0x00, parent: saveFileController, initialValue: 0x12345678);
      expect(controller.value, equals(0x12345678));
      expect(controller.isDirty, isTrue);
    });

    test('Controller with invalid initial value', () {
      expect(() => TTUint32Controller(0x00, parent: saveFileController, initialValue: -1),
          throwsA(isA<AssertionError>()));
      expect(() => TTUint32Controller(0x00, parent: saveFileController, initialValue: 0x1FFFFFFFF),
          throwsA(isA<AssertionError>()));
    });

    test('Controller with initial value, big endian', () {
      saveFile.endian = Endian.big;
      controller = TTUint32Controller(0x0C, parent: saveFileController, initialValue: 0x0C0D0EFF);
      expect(controller.value, equals(0x0C0D0EFF));
      expect(controller.isDirty, isFalse);
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x12;
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.value = 0x13;
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.value = 0xFF1E1D1C;
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint32(0x0C), equals(0xFF1E1D1C));
      expect(controller.value, equals(0xFF1E1D1C));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.value = 0xFF1E1D1C;
      controller.cancelChanges();
      expect(saveFile.getUint32(0x0C), equals(0xFF0E0D0C));
      expect(controller.value, equals(0xFF0E0D0C));
      expect(controller.isDirty, isFalse);
    });
  });

  group('TTFloat32Controller', () {
    late TTFloat32Controller controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTFloat32Controller(0x0C, parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals(-1.8881811864953425e+38));
      expect(controller.isDirty, isFalse);
    });

    test('Controller reads correct value, big endian', () {
      saveFile.endian = Endian.big;
      controller.cancelChanges();
      expect(controller.value, equals(1.0866757609156817e-31));
      expect(controller.isDirty, isFalse);
    });

    test('Controller reads infinity, negative infinity, nan', () {
      saveFile.setUint32(0x0C, 0x7F800000);
      controller.cancelChanges();
      expect(controller.value, equals(double.infinity));
      saveFile.setUint32(0x0C, 0xFF800000);
      controller.cancelChanges();
      expect(controller.value, equals(double.negativeInfinity));
      saveFile.setUint32(0x0C, 0x7F800001);
      controller.cancelChanges();
      expect(controller.value, isNaN);
    });

    test('Controller with initial value', () {
      controller = TTFloat32Controller(0x00, parent: saveFileController, initialValue: 5.5);
      expect(controller.value, equals(5.5));
      expect(controller.isDirty, isTrue);
    });

    test('Controller with initial value, big endian', () {
      saveFile.endian = Endian.big;
      controller = TTFloat32Controller(0x0C,
          parent: saveFileController, initialValue: 1.0866757609156817e-31);
      expect(controller.value, equals(1.0866757609156817e-31));
      expect(controller.isDirty, isFalse);
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x10;
      expect(flag, isTrue);
      controller.value = 0x12;
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.value = 0x13;
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.value = 3.35;
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint32(0x0C), equals(0x40566666));
      expect(controller.value, equals(3.35));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.value = 255.255;
      controller.cancelChanges();
      expect(saveFile.getUint32(0x0C), equals(0xFF0E0D0C));
      expect(controller.value, equals(-1.8881811864953425e+38));
      expect(controller.isDirty, isFalse);
    });
  });

  group('TTBooleanController', () {
    late TTBooleanController controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTBooleanController(0x00, parent: saveFileController);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals(false));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with initial value', () {
      controller = TTBooleanController(0x00, parent: saveFileController, initialValue: false);
      expect(controller.value, equals(false));
      expect(controller.isDirty, isFalse);
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.value = true;
      expect(flag, isTrue);
      controller.value = true;
      expect(flag, isTrue);
      controller.value = false;
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.value = true;
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.value = true;
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint32(0x00), equals(0x03020101));
      expect(controller.value, equals(true));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.value = true;
      controller.cancelChanges();
      expect(saveFile.getUint32(0x00), equals(0x03020100));
      expect(controller.value, equals(false));
      expect(controller.isDirty, isFalse);
    });
  });

  group('TTBitmapController', () {
    late TTBitmapController controller;

    setUp(() {
      setUpSaveFileAndSaveFileController();
      controller = TTBitmapController(0x00, parent: saveFileController, bitLength: 16);
    });

    test('Controller has correct structure', () {
      expect(controller.parent, same(saveFileController));
      expect(controller.saveData, same(controller.parent.saveData));
      expect(controller.saveFile, same(saveFile));
    });

    test('Controller reads correct value', () {
      expect(controller.value, equals([0x00, 0x01]));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with clean initial value', () {
      var values = Uint8List.fromList(const [0x00, 0x01]);
      controller =
          TTBitmapController(0x00, parent: saveFileController, bitLength: 16, initialValue: values);
      expect(controller.value, equals(values));
      expect(controller.isDirty, isFalse);
    });

    test('Controller with dirty initial value', () {
      var values = Uint8List.fromList(const [0x00, 0x02]);
      controller =
          TTBitmapController(0x00, parent: saveFileController, bitLength: 16, initialValue: values);
      expect(controller.value, equals(values));
      expect(controller.isDirty, isTrue);
    });

    test('Controller with invalid initial value', () {
      var values = Uint8List.fromList([0x00, 0x01]);
      expect(
          () => TTBitmapController(0x00,
              parent: saveFileController, bitLength: -1, initialValue: values),
          throwsA(isA<AssertionError>()));
      expect(
          () => TTBitmapController(0x00,
              parent: saveFileController, bitLength: 7, initialValue: values),
          throwsA(isA<AssertionError>()));
      expect(
          () => TTBitmapController(0x00,
              parent: saveFileController, bitLength: 17, initialValue: values),
          throwsA(isA<AssertionError>()));
    });

    test('Controller answers correct bit values', () {
      expect(controller.bit(0), isFalse);
      expect(controller.bit(8), isTrue);
      expect(controller.bit(15), isFalse);
      expect(controller.isDirty, isFalse);
      expect(controller.totalBitsSet(), equals(1));
      controller.setBit(1);
      controller.setBit(9);
      expect(controller.bit(1), isTrue);
      expect(controller.bit(9), isTrue);
      expect(controller.isDirty, isTrue);
      expect(controller.totalBitsSet(), equals(3));
    });

    test('Controller answers valid totalBitsSet()', () {
      var values = Uint8List.fromList(const [0x00, 0xFF]);
      controller =
          TTBitmapController(0x00, parent: saveFileController, bitLength: 15, initialValue: values);
      expect(controller.totalBitsSet(), equals(7), reason: 'Bit 15 is outside range of bitmap');
      controller.setBit(1);
      controller.setBit(7);
      expect(controller.totalBitsSet(), equals(9));
      controller.unsetBit(0); // should do nothing
      controller.unsetBit(1);
      controller.unsetBit(7);
      controller.unsetBit(10);
      expect(controller.totalBitsSet(), equals(6));
    });

    test('Controller calls listener when expected', () {
      bool flag = false;
      listener() => flag = !flag;

      controller.addListener(listener);
      controller.setBit(0);
      expect(flag, isTrue);
      controller.setBit(0);
      expect(flag, isTrue);
      controller.setBit(1);
      expect(flag, isFalse);
      controller.removeListener(listener);
      controller.unsetBit(1);
      expect(flag, isFalse);
    });

    test('Controller writes value to save', () {
      controller.setBit(0);
      controller.setBit(3);
      controller.setBit(7);
      controller.setBit(14);
      expect(controller.isDirty, isTrue);
      controller.saveChanges();
      expect(saveFile.getUint16(0x00), equals(0x4189));
      expect(controller.value, equals(const [0x89, 0x41]));
      expect(controller.isDirty, isFalse);
    });

    test('Controller cancels changes correctly', () {
      controller.setBit(0);
      controller.setBit(3);
      controller.setBit(7);
      controller.setBit(14);
      controller.cancelChanges();
      expect(saveFile.getUint32(0x00), equals(0x03020100));
      expect(controller.value, equals([0x00, 0x01]));
      expect(controller.isDirty, isFalse);
    });
  });
}
