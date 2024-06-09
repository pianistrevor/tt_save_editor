import 'dart:typed_data';

import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';
import 'package:tt_save_editor/model/_core/tt_save_file.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_levels.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_minikits.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_misc_section.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_shop.dart';

const kLSW1SaveFileLength = 0x214;

class LSW1SaveFile extends TTSaveFile {
  LSW1SaveFile(super.filename) : super(endian: Endian.little);

  LSW1SaveFile.fromBytes(super.fileBytes) : super.fromBytes(endian: Endian.little);

  LSW1SaveFile.blank() : super.blank(kLSW1SaveFileLength, endian: Endian.little);
}

class LSW1SaveFileController extends TTSaveFileController {
  LSW1SaveFileController({required super.saveFile}) {
    _initializeChildren();
  }

  void _initializeChildren() {
    misc = LSW1MiscSectionController(parent: this);
    minikits = LSW1MinikitsController(parent: this);
    levels = LSW1LevelsController(parent: this);
    shop = LSW1ShopController(parent: this);
    studCountController = TTInt32Controller(0x204, parent: this);
    hintsController = TTBitmapController(0x208, parent: this, bitLength: 27);
    // Initialize superclass checksumController
    checksumController = TTUint32Controller(0x210, parent: this);
  }

  @override
  List<TTChildController> get children =>
      [misc, minikits, levels, shop, studCountController, hintsController];

  /// Call this on a blank save file and it will set the appropriate values for
  /// a legal initial save file.
  void initializeSaveFile() {
    saveFile.setUint8(1, 0x5);
    // Default options settings from the menu, otherwise these won't be set
    misc.enableAutoSave();
    misc.setSfxVolume(8);
    misc.setMusicVolume(6);
    misc.setMasterVolume(10);
    misc.enableMusic();

    levels.negotiations.unlock();
    shop.unlockCharacter('quiGonJinn');
    shop.unlockCharacter('obiWanKenobi');
    saveChanges();
  }

  // API

  /// The number of studs collected, as shown in the hub. This is a signed value
  /// so any values > 2,147,483,648 will become negative.
  int get studCount => studCountController.value;
  void setStudCount(int newValue) => studCountController.value = newValue;

  /// The checksum of the save file. If this value is incorrect, the game will
  /// report "Load Corrupted" when trying to load the save file.
  ///
  /// Calculated as the sum of 4-byte values from 0x000 until 0x210
  @override
  int calculateChecksum() {
    var sum = saveFile
        .bytesAsUint32(0, 0x210)
        .fold(0, (runningTotal, newElement) => runningTotal + newElement);
    return sum & 0xFFFFFFFF;
  }

  /// Whether a hint at a given index has been shown in-game. This is a sparse
  /// bitmap and only 13 indices are known to be triggered through in-game events.
  bool hintShown(int index) => hintsController.bit(index);
  void setHintShown(int index) => hintsController.setBit(index);
  void unsetHintShown(int index) => hintsController.unsetBit(index);

  late final LSW1MiscSectionController misc;
  late final LSW1MinikitsController minikits;
  late final LSW1LevelsController levels;
  late final LSW1ShopController shop;
  late final TTInt32Controller studCountController;
  late final TTBitmapController hintsController;
}
