import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';

bool isUint8(int value) => value & 0xFF == value;

bool isInt8(int value) => value >= -128 && value <= 127;

bool isUint32(int value) => value & 0xFFFFFFFF == value;

bool isInt32(int value) => value >= -2147483648 && value <= 2147483647;

/// A controller responsible for updating a value in the save file.
///
/// These controller values will generally stick to low-level operations
/// such as bytes, booleans, floats, and bitmaps
abstract class TTValueController<T> extends TTChildController with ChangeNotifier {
  TTValueController(this.offset, {required super.parent, T? initialValue}) {
    var saveValue = saveValueRead();
    _value = initialValue ?? saveValue;
    if (!valueEquals(saveValue)) _dirty = true; // TODO: do I need to notify listeners?
  }

  @override
  void saveChanges() {
    if (!_dirty) return;
    saveValueSet(_value);
    _dirty = false;
  }

  @override
  void cancelChanges() {
    final oldValue = _value;
    _value = saveValueRead();
    _dirty = false;
    if (!valueEquals(oldValue)) notifyListeners();
  }

  @override
  bool get isDirty => _dirty;

  @override
  Never get children => throw Exception('Should not be accessing value controller\'s children');

  /// Equality helper method. Can be overridden for things like collections as
  /// the templated [value].
  bool valueEquals(T otherValue) => _value == otherValue;

  /// Called to read the controller's value from save file.
  T saveValueRead();

  /// Called when writing the controller's value to save file.
  void saveValueSet(T newValue);

  T get value => _value;
  set value(T newValue) {
    if (valueEquals(newValue)) return;
    _dirty = true;
    _value = newValue;
    notifyListeners();
  }

  int offset;
  late T _value;
  bool _dirty = false;
}

class TTUint8Controller extends TTValueController<int> {
  TTUint8Controller(super.offset, {required super.parent, super.initialValue})
      : assert(initialValue == null || isUint8(initialValue),
            'Initial value $initialValue is not a Uint8');

  @override
  int saveValueRead() => saveFile.getUint8(offset);

  @override
  void saveValueSet(int newValue) {
    assert(isInt8(newValue), "Value $newValue is not a Uint8");
    saveFile.setUint8(offset, newValue);
  }

  @override
  set value(int newValue) {
    assert(isInt8(newValue), "Value $newValue is not a Uint8");
    super.value = newValue;
  }
}

class TTInt32Controller extends TTValueController<int> {
  TTInt32Controller(super.offset, {required super.parent, super.initialValue})
      : assert(initialValue == null || isInt32(initialValue),
            'Initial value $initialValue is not an Int32');

  @override
  int saveValueRead() => saveFile.getInt32(offset);

  @override
  void saveValueSet(int newValue) {
    assert(isInt32(newValue), "Value $newValue is not an Int32");
    saveFile.setInt32(offset, newValue);
  }

  @override
  set value(int newValue) {
    assert(isInt32(newValue), "Value $newValue is not a Int32");
    super.value = newValue;
  }
}

class TTUint32Controller extends TTValueController<int> {
  TTUint32Controller(super.offset, {required super.parent, super.initialValue})
      : assert(initialValue == null || isUint32(initialValue),
            'Initial value $initialValue is not a Uint32');

  @override
  int saveValueRead() => saveFile.getUint32(offset);

  @override
  void saveValueSet(int newValue) {
    assert(isUint32(newValue), "Value $newValue is not a Uint32");
    saveFile.setUint32(offset, newValue);
  }

  @override
  set value(int newValue) {
    assert(isUint32(newValue), "Value $newValue is not a Uint32");
    super.value = newValue;
  }
}

class TTFloat32Controller extends TTValueController<double> {
  TTFloat32Controller(super.offset, {required super.parent, super.initialValue});

  @override
  double saveValueRead() => saveFile.getFloat32(offset);

  @override
  void saveValueSet(double newValue) {
    saveFile.setFloat32(offset, newValue);
  }
}

class TTBooleanController extends TTValueController<bool> {
  TTBooleanController(super.offset, {required super.parent, super.initialValue});

  @override
  bool saveValueRead() => saveFile.getUint8(offset) != 0;

  @override
  void saveValueSet(bool newValue) => saveFile.setUint8(offset, newValue ? 1 : 0);
}

class TTBitmapController extends TTValueController<Uint8List> {
  TTBitmapController(super.offset,
      {required super.parent, required this.bitLength, super.initialValue})
      : assert(bitLength > 0, 'Must have positive bitLength'),
        assert(initialValue == null || initialValue.length == (bitLength / 8).ceil(),
            'Length of Uint8List mismatches bitLength'),
        byteLength = (bitLength / 8).ceil();

  @override
  set value(Uint8List newValue) {
    assert(false, 'Should not public value setter on TTBitmapController');
    super.value = newValue;
  }

  @override
  bool valueEquals(Uint8List otherValue) {
    if (value.length != otherValue.length) return false;
    for (int i = 0; i < value.length; ++i) {
      if (value[i] != otherValue[i]) return false;
    }
    return true;
  }

  @override
  Uint8List saveValueRead() => saveFile.copyRange(offset, offset + byteLength);

  @override
  void saveValueSet(Uint8List newValue) =>
      saveFile.writeRange(offset, offset + byteLength, newValue);

  bool bit(int bitOffset) {
    _ensureValidOffset(bitOffset);
    var (byteOffs, bitOffs) = (bitOffset ~/ 8, bitOffset % 8);
    return (value[byteOffs] >> bitOffs) & 1 == 1;
  }

  void setBit(int bitOffset) {
    _ensureValidOffset(bitOffset);
    var (byteOffs, bitOffs) = (bitOffset ~/ 8, bitOffset % 8);
    var oldValue = value[byteOffs];
    var newValue = oldValue | (1 << bitOffs);
    if (newValue == oldValue) return;
    value[byteOffs] = newValue;
    _dirty = true;
    notifyListeners();
  }

  void unsetBit(int bitOffset) {
    _ensureValidOffset(bitOffset);
    var (byteOffs, bitOffs) = (bitOffset ~/ 8, bitOffset % 8);
    var oldValue = value[byteOffs];
    var newValue = oldValue & (~(1 << bitOffs) & 0xFF);
    if (newValue == oldValue) return;
    value[byteOffs] = newValue;
    _dirty = true;
    notifyListeners();
  }

  /// The total number of bits set in this bitmap. If the [bitLength] is not
  /// byte-aligned, it will only check up to the bit that it ends at.
  int totalBitsSet() {
    int count = 0;
    int bitsToTestLeft = bitLength;
    for (var byte in value) {
      int bitsToTestInThisByte = min(bitsToTestLeft, 8);
      bitsToTestLeft -= bitsToTestInThisByte;
      for (bitsToTestInThisByte; bitsToTestInThisByte > 0; --bitsToTestInThisByte) {
        count += byte & 1;
        byte >>= 1;
      }
      if (bitsToTestLeft == 0) return count;
    }
    throw Exception('Shouldn\'t get here. bitsToTestLeft = $bitsToTestLeft');
  }

  void _ensureValidOffset(int bitOffset) {
    if (bitOffset < 0 || bitOffset >= bitLength) throw 'Invalid offset for bitmap: $bitOffset';
  }

  /// The number of bits in the bitmap
  final int bitLength;

  /// The length of the bitmap, in bytes
  final int byteLength;
}
