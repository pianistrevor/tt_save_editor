import 'dart:typed_data';
import 'package:test/test.dart';
import 'test_data.dart';

void main() {
  late TTTestSaveFile saveFile;

  setUp(() {
    var bytes = Uint8List.fromList(kTestFileBytes);
    saveFile = TTTestSaveFile.fromBytes(bytes, endian: Endian.little);
  });

  test('Test correct setup', () {
    expect(saveFile.endian, same(Endian.little));
    // Structures
    expect(saveFile.bytes.offsetInBytes, isZero);
    expect(saveFile.byteList.buffer, equals(saveFile.bytes.buffer));
    expect(saveFile.bytesAsUint32().buffer, equals(saveFile.bytes.buffer));
    expect(saveFile.readRange(0, 8).buffer, equals(saveFile.bytes.buffer));
    expect(saveFile.copyRange(9, 15).buffer, isNot(equals(saveFile.bytes.buffer)));
    // Index errors
    expect(() => saveFile.getUint8(-1), throwsA(isA<IndexError>()));
    expect(() => saveFile.getInt8(16), throwsA(isA<IndexError>()));
    expect(() => saveFile.getUint16(15), throwsA(isA<IndexError>()));
    expect(() => saveFile.getFloat32(13), throwsA(isA<IndexError>()));
    expect(() => saveFile.setUint8(-1, 42), throwsA(isA<IndexError>()));
    expect(() => saveFile.setInt8(16, 42), throwsA(isA<IndexError>()));
    expect(() => saveFile.setUint16(15, 42), throwsA(isA<IndexError>()));
    expect(() => saveFile.setFloat32(13, 42), throwsA(isA<IndexError>()));
    expect(() => saveFile.writeRange(15, 17, Uint8List.fromList([0xFF, 0xFE])),
        throwsA(isA<RangeError>()));
  });

  test('Getting values gives correct result', () {
    // Bytes
    expect(saveFile.getUint8(0), equals(0x00));
    expect(saveFile.getInt8(0), isZero);
    expect(saveFile.getUint8(15), equals(255));
    expect(saveFile.getInt8(15), equals(-1));
    // Half words
    expect(saveFile.getUint16(1), equals(0x0201));
    expect(saveFile.getInt16(1), equals(0x0201));
    expect(saveFile.getUint16(9), equals(0x8A09));
    expect(saveFile.getInt16(9), equals(-30199));
    // Double words
    expect(saveFile.getUint32(1), equals(0x04030201));
    expect(saveFile.getInt32(1), equals(0x04030201));
    expect(saveFile.getUint32(12), equals(0xFF0E0D0C));
    expect(saveFile.getInt32(12), equals(-15856372));
    // Float
    expect(saveFile.getFloat32(0), equals(3.820471434542632e-37));
    expect(saveFile.getFloat32(12), equals(-1.8881811864953425e+38));
  });

  test('Getting values gives correct result, big endian', () {
    saveFile.endian = Endian.big;
    // Half words
    expect(saveFile.getUint16(0), equals(1));
    expect(saveFile.getInt16(0), equals(1));
    expect(saveFile.getUint16(10), equals(0x8A0B));
    expect(saveFile.getInt16(10), equals(-30197));
    // Double words
    expect(saveFile.getUint32(1), equals(0x01020304));
    expect(saveFile.getInt32(1), equals(0x01020304));
    expect(saveFile.getUint32(12), equals(0x0C0D0EFF));
    expect(saveFile.getInt32(12), equals(0x0C0D0EFF));
    // Float
    expect(saveFile.getFloat32(0), equals(9.25571648671185e-41));
    expect(saveFile.getFloat32(12), equals(1.0866757609156817e-31));
  });

  test('Writing values to save', () {
    saveFile.setUint8(0, 1);
    expect(saveFile.getUint8(0), equals(1));
    expect(saveFile.byteList[0], equals(1), reason: 'byteList should have same buffer');
    saveFile.setUint16(1, 2);
    expect(saveFile.getUint16(0), equals(0x0201));
    saveFile.setInt16(1, -1);
    expect(saveFile.getUint16(0), equals(0xFF01));
    expect(saveFile.getInt16(0), equals(-255));
    saveFile.setUint32(0, 0xFEDCBA98);
    expect(saveFile.getUint32(0), equals(0xFEDCBA98));
    expect(saveFile.getInt32(0), equals(-19088744));
    expect(saveFile.bytesAsUint32()[0], equals(0xFEDCBA98),
        reason: 'bytesAsUint32() should have same buffer');

    saveFile.setUint32(0, 0x43960000); // reinterpret bytes
    expect(saveFile.getFloat32(0), equals(300));

    saveFile.writeRange(1, 5, Uint8List.fromList([0xFF, 0xFE, 0xFD, 0xFC]));
    expect(saveFile.getUint32(1), equals(0xFCFDFEFF));
    expect(saveFile.getInt32(1), equals(-50462977));
  });

  test('Writing values to save, big endian', () {
    saveFile.endian = Endian.big;
    saveFile.setUint8(0, 1);
    expect(saveFile.getUint8(0), equals(1));
    saveFile.setUint16(1, 2);
    expect(saveFile.getUint16(0), equals(0x0100));
    saveFile.setInt16(1, -1);
    expect(saveFile.getUint16(0), equals(0x01FF));
    expect(saveFile.getInt16(0), equals(0x01FF));
    saveFile.setUint32(0, 0xFEDCBA98);
    expect(saveFile.getUint32(0), equals(0xFEDCBA98));
    expect(saveFile.getInt32(0), equals(-19088744));
    expect(saveFile.bytesAsUint32()[0], equals(0x98BADCFE),
        reason: 'bytesAsUint32() should reinterpret byte order');

    saveFile.writeRange(0, 4, Uint8List.fromList([0x43, 0x96, 0x00, 0x00])); // reinterpret bytes
    expect(saveFile.getFloat32(0), equals(300));

    saveFile.writeRange(1, 5, Uint8List.fromList([0xFF, 0xFE, 0xFD, 0xFC]));
    expect(saveFile.getUint32(1), equals(0xFFFEFDFC));
    expect(saveFile.getInt32(1), equals(-66052));
  });

  test('Truncating values', () {
    // Test out of bounds value setting errors
    saveFile.setUint8(0, 256);
    expect(saveFile.getUint8(0), isZero);
    saveFile.setInt8(0, -511); // 0xFE01 -> 0x01
    expect(saveFile.getInt8(0), equals(1));
    saveFile.setUint16(0, 0xFFFFF);
    expect(saveFile.getUint16(0), equals(0xFFFF));
    saveFile.setInt16(0, 65791); // 0x100FF -> 0xFF
    expect(saveFile.getInt16(0), equals(255));
    saveFile.setUint32(0, 0x123456789A);
    expect(saveFile.getUint32(0), equals(0x3456789A));
    saveFile.setInt32(0, 0x1F1111111);
    expect(saveFile.getInt32(0), equals(-250539759));
  });
}
