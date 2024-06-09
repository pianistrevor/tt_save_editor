import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';

/// The section at the beginning of the file. Handles miscellaneous options such
/// as the superkit count, config, etc
class LSW1MiscSectionController extends TTChildController {
  LSW1MiscSectionController({required super.parent}) {
    _initializeChildren();
  }

  void _initializeChildren() {
    superkitCountController = TTUint8Controller(0x02, parent: this);
    episode2and3ZoomController = TTBooleanController(0x03, parent: this);
    autoSaveController = TTBooleanController(0x04, parent: this);
    surroundSoundController = TTBooleanController(0x05, parent: this);
    sfxVolumeController = TTUint8Controller(0x06, parent: this);
    musicVolumeController = TTUint8Controller(0x07, parent: this);
    masterVolumeController = TTUint8Controller(0x08, parent: this);
    musicController = TTBooleanController(0x09, parent: this);
    reverseUpDownController = TTBooleanController(0x0C, parent: this);
  }

  @override
  List<TTChildController> get children => [
        superkitCountController,
        episode2and3ZoomController,
        autoSaveController,
        surroundSoundController,
        sfxVolumeController,
        musicVolumeController,
        masterVolumeController,
        musicController,
        reverseUpDownController,
      ];

  // API

  /// The total number of superkit pieces obtained. Range is 0-17. Values greater
  /// than 17 have the same effect as 17.
  int get superkitCount => superkitCountController.value;
  void setSuperkitCount(int newValue) => superkitCountController.value = newValue;

  /// Whether the game will zoom in on the "Episode II" and "Episode III" doors
  /// on launch. This only happens after beating the first level, which unlocks
  /// the doors, and is disabled upon the next save.
  bool get episode2and3ZoomEnabled => !episode2and3ZoomController.value;
  void enableEpisode2and3Zoom() => episode2and3ZoomController.value = false;
  void disableEpisode2and3Zoom() => episode2and3ZoomController.value = true;

  /// Whether the menu option Options > Auto-Save was set to "On" during the last save.
  bool get autoSaveEnabled => autoSaveController.value;
  void enableAutoSave() => autoSaveController.value = true;
  void disableAutoSave() => autoSaveController.value = false;

  /// Whether the menu option Options > Surround Sound was set to "On" during the last save.
  bool get surroundSoundEnabled => surroundSoundController.value;
  void enableSurroundSound() => surroundSoundController.value = true;
  void disableSurroundSound() => surroundSoundController.value = false;

  /// The volume level of in-game sound effects. Range 0-10. Value is hardcoded to 8 and
  /// unchangeable in-game.
  int get sfxVolume => sfxVolumeController.value;
  void setSfxVolume(int newValue) => sfxVolumeController.value = newValue;

  /// The volume level of in-game music. Range 0-10. Value changes between 6 (if saved
  /// after exiting a level) and 4 (otherwise). Unchangeable in-game.
  int get musicVolume => musicVolumeController.value;
  void setMusicVolume(int newValue) => musicVolumeController.value = newValue;

  /// Value of the menu option Options > Audio Volume during the last save. Range 0-10.
  /// Values greater than 10 are treated as 10 in-game.
  int get masterVolume => masterVolumeController.value;
  void setMasterVolume(int newValue) => masterVolumeController.value = newValue;

  /// Whether the menu option Options > Music was set to "On" during the last save.
  bool get musicEnabled => musicController.value;
  void enableMusic() => musicController.value = true;
  void disableMusic() => musicController.value = false;

  /// Whether the menu option Options > Reverse up/down was set to "Yes" during the last save.
  /// Only visible in the level "Battle over Coruscant".
  bool get reverseUpDownEnabled => reverseUpDownController.value;
  void enableReverseUpDown() => reverseUpDownController.value = true;
  void disableReverseUpDown() => reverseUpDownController.value = false;

  late final TTUint8Controller superkitCountController;
  late final TTBooleanController episode2and3ZoomController;
  late final TTBooleanController autoSaveController;
  late final TTBooleanController surroundSoundController;
  late final TTUint8Controller sfxVolumeController;
  late final TTUint8Controller musicVolumeController;
  late final TTUint8Controller masterVolumeController;
  late final TTBooleanController musicController;
  late final TTBooleanController reverseUpDownController;
}
