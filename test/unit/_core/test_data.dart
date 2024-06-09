import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';
import 'package:tt_save_editor/model/_core/tt_save_file.dart';

class TTTestSaveFile extends TTSaveFile {
  TTTestSaveFile.fromBytes(super.bytes, {required super.endian}) : super.fromBytes();
}

class TTTestSaveFileController extends TTSaveFileController {
  TTTestSaveFileController({required super.saveFile}) {
    // Initialize checksum controller at last byte
    checksumController = TTUint32Controller(0xC, parent: this);
  }

  /// Easy checksum calculation: add up all the bytes together except for the last
  /// 4 bytes and truncate to 4 bytes
  @override
  int calculateChecksum() =>
      saveFile.bytesAsUint32(0, 12).fold(0, (runningTotal, newByte) => runningTotal + newByte) &
      0xFFFFFFFF;

  @override
  List<TTChildController> get children => const [];
}

class TTTestCompositeController extends TTChildController {
  TTTestCompositeController({required super.parent});

  @override
  List<TTChildController> get children => const [];
}

const kTestFileBytes = [
  0x00,
  0x01,
  0x02,
  0x03,
  0x04,
  0x05,
  0x06,
  0x07,
  0x08,
  0x09,
  0x8A,
  0x0B,
  0x0C,
  0x0D,
  0x0E,
  0xFF,
];
