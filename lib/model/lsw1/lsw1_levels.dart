import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';

class LSW1LevelsController extends TTChildController {
  LSW1LevelsController({required super.parent}) {
    _initializeChildren();
  }

  void _initializeChildren() {
    for (final entry in kLevelFlagsData.entries) {
      final (levelString, offset) = (entry.key, entry.value);
      _levels[levelString] = LSW1LevelFlagsController(offset, parent: this);
    }
    aNewHopeUnlockedController = TTBooleanController(0x1B0, parent: this);
    aNewHopeCompletedController = TTBooleanController(0x1B1, parent: this);
  }

  @override
  List<TTChildController> get children => [
        ..._levels.values,
        aNewHopeUnlockedController,
        aNewHopeCompletedController,
      ];

  // API

  LSW1LevelFlagsController get negotiations => _levels['negotiations']!;
  LSW1LevelFlagsController get invasionOfNaboo => _levels['invasionOfNaboo']!;
  LSW1LevelFlagsController get escapeFromNaboo => _levels['escapeFromNaboo']!;
  LSW1LevelFlagsController get mosEspaPodrace => _levels['mosEspaPodrace']!;
  LSW1LevelFlagsController get retakeTheedPalace => _levels['retakeTheedPalace']!;
  LSW1LevelFlagsController get darthMaul => _levels['darthMaul']!;
  LSW1LevelFlagsController get discoveryOnKamino => _levels['discoveryOnKamino']!;
  LSW1LevelFlagsController get droidFactory => _levels['droidFactory']!;
  LSW1LevelFlagsController get jediBattle => _levels['jediBattle']!;
  LSW1LevelFlagsController get gunshipCalvary => _levels['gunshipCalvary']!;
  LSW1LevelFlagsController get countDooku => _levels['countDooku']!;
  LSW1LevelFlagsController get battleOverCoruscant => _levels['battleOverCoruscant']!;
  LSW1LevelFlagsController get chancellorInPeril => _levels['chancellorInPeril']!;
  LSW1LevelFlagsController get generalGrievous => _levels['generalGrievous']!;
  LSW1LevelFlagsController get defenseOfKashyyyk => _levels['defenseOfKashyyyk']!;
  LSW1LevelFlagsController get ruinOfTheJedi => _levels['ruinOfTheJedi']!;
  LSW1LevelFlagsController get darthVader => _levels['darthVader']!;

  /// Whether the "?" door in the diner is greenlit and can be entered.
  bool get aNewHopeUnlocked => aNewHopeUnlockedController.value;
  void unlockANewHope() => aNewHopeUnlockedController.value = true;
  void lockANewHope() => aNewHopeUnlockedController.value = false;

  /// Whether the "?" door level has been completed in story mode.
  bool get aNewHopeCompleted => aNewHopeCompletedController.value;
  void completeANewHope() => aNewHopeCompletedController.value = true;
  void uncompleteANewHope() => aNewHopeCompletedController.value = false;

  final Map<String, LSW1LevelFlagsController> _levels = {};
  late final TTBooleanController aNewHopeUnlockedController;
  late final TTBooleanController aNewHopeCompletedController;
}

class LSW1LevelFlagsController extends TTChildController {
  LSW1LevelFlagsController(int offset, {required super.parent}) : _offset = offset {
    _initializeChildren();
  }

  void _initializeChildren() {
    unlockedController = TTBooleanController(_offset, parent: this);
    completedController = TTBooleanController(_offset + 1, parent: this);
    superkitObtainedController = TTBooleanController(_offset + 2, parent: this);
    minikitObtainedController = TTBooleanController(_offset + 3, parent: this);
    minikitCountController = TTUint8Controller(_offset + 4, parent: this);
  }

  @override
  List<TTChildController> get children => [
        unlockedController,
        completedController,
        superkitObtainedController,
        minikitObtainedController,
        minikitCountController,
      ];

  // API

  /// Whether the level's door in the diner is greenlit and can be entered.
  bool get unlocked => unlockedController.value;
  void unlock() => unlockedController.value = true;
  void lock() => unlockedController.value = false;

  /// Whether the level has been completed in story mode.
  bool get completed => completedController.value;
  void complete() => completedController.value = true;
  void uncomplete() => completedController.value = false;

  /// Whether the superkit piece (stud meter filled in the level HUD) has been obtained.
  bool get superkitObtained => superkitObtainedController.value;
  void obtainSuperkit() => superkitObtainedController.value = true;
  void unobtainSuperkit() => superkitObtainedController.value = false;

  /// Whether the minikit build (10 minikits collected) has been completed.
  bool get minikitObtained => minikitObtainedController.value;
  void obtainMinikit() => minikitObtainedController.value = true;
  void unobtainMinikit() => minikitObtainedController.value = false;

  /// Integer count of the number of minikits collected. Range: 0-10.
  ///
  /// Note that
  /// values >= 10 without the [minikitObtained] flag set to true will show
  /// a complete build outside the diner, but lack the name of the build.
  int get minikitCount => minikitCountController.value;
  void setMinikitCount(int newValue) => minikitCountController.value = newValue;

  late final TTBooleanController unlockedController;
  late final TTBooleanController completedController;
  late final TTBooleanController superkitObtainedController;
  late final TTBooleanController minikitObtainedController;
  late final TTUint8Controller minikitCountController;

  /// The initial offset of the level flags for the given level
  final int _offset;
}

const kLevelFlagsData = <String, int>{
  'negotiations': 0x110,
  'invasionOfNaboo': 0x118,
  'escapeFromNaboo': 0x120,
  'mosEspaPodrace': 0x128,
  'retakeTheedPalace': 0x130,
  'darthMaul': 0x138,
  'discoveryOnKamino': 0x148,
  'droidFactory': 0x150,
  'jediBattle': 0x158,
  'gunshipCalvary': 0x160,
  'countDooku': 0x168,
  'battleOverCoruscant': 0x178,
  'chancellorInPeril': 0x180,
  'generalGrievous': 0x188,
  'defenseOfKashyyyk': 0x190,
  'ruinOfTheJedi': 0x198,
  'darthVader': 0x1A0,
};
