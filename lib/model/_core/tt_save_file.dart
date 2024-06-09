import 'dart:io';
import 'dart:typed_data';

/// An in-memory representation of the raw save file.
///
/// Its interface primarily involves exposing its raw data to the controllers
/// that access it, and writing to and from disk.
abstract class TTSaveFile {
  TTSaveFile(String filename, {required this.endian}) {
    var file = File(filename);
    byteList = file.readAsBytesSync();
    bytes = ByteData.view(byteList.buffer);
    _file = file;
  }

  TTSaveFile.fromBytes(Uint8List fileBytes, {required this.endian}) {
    byteList = fileBytes;
    bytes = ByteData.view(fileBytes.buffer);
  }

  TTSaveFile.blank(int length, {required this.endian}) {
    byteList = Uint8List(length);
    bytes = ByteData.view(byteList.buffer);
  }

  /// VIEW: The list of bytes as 32-bit unsigned integers. Useful for the checksum operation.
  Uint32List bytesAsUint32([int? start, int? end]) =>
      Uint32List.sublistView(bytes, start ?? 0, end);

  // The following are helper methods for the save file to use its own endian

  int getUint8(int offs) => bytes.getUint8(offs);
  int getInt8(int offs) => bytes.getInt8(offs);
  int getUint16(int offs) => bytes.getUint16(offs, endian);
  int getInt16(int offs) => bytes.getInt16(offs, endian);
  int getUint32(int offs) => bytes.getUint32(offs, endian);
  int getInt32(int offs) => bytes.getInt32(offs, endian);
  double getFloat32(int offs) => bytes.getFloat32(offs, endian);

  void setUint8(int offs, int value) => bytes.setUint8(offs, value);
  void setInt8(int offs, int value) => bytes.setInt8(offs, value);
  void setUint16(int offs, int value) => bytes.setUint16(offs, value, endian);
  void setInt16(int offs, int value) => bytes.setInt16(offs, value, endian);
  void setUint32(int offs, int value) => bytes.setUint32(offs, value, endian);
  void setInt32(int offs, int value) => bytes.setInt32(offs, value, endian);
  void setFloat32(int offs, double value) => bytes.setFloat32(offs, value, endian);

  /// Get a COPY of a subset of bytes (new buffer). Start inclusive, end exclusive
  Uint8List copyRange(int start, int end) => byteList.sublist(start, end);

  /// Get a VIEW of a subset of bytes (actual data). Start inclusive, end exclusive
  Uint8List readRange(int start, int end) => Uint8List.sublistView(byteList, start, end);

  /// Set a subset of bytes (actual data)
  void writeRange(int start, int end, Uint8List data) => byteList.setRange(start, end, data);

  /// Writes the [File] object associated with this save file, if it exists, to disk
  void writeFileToDisk() {
    _file?.writeAsBytesSync(byteList);
  }

  /// endian of the save file
  Endian endian;

  /// VIEW: The list of bytes as an iterable. Useful for getting sublists, doing modifications, etc
  late final Uint8List byteList;

  /// VIEW: The list of bytes as a random-access byte chunk. Useful for quick operations on single bytes
  /// and reinterpreting bytes
  late final ByteData bytes;

  File? _file;
}
