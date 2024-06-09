import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';

class LSW1MinikitsController extends TTChildController {
  LSW1MinikitsController({required super.parent}) {
    _initializeChildren();
  }

  void _initializeChildren() {
    for (final entry in kLevelMinikitsData.entries) {
      final (levelString, sections) = (entry.key, entry.value);
      _levels[levelString] = LSW1LevelMinikitsController(
        parent: this,
        sections: sections,
      );
    }
  }

  @override
  List<TTChildController> get children => _levels.values.toList();

  // API

  LSW1LevelMinikitsController get negotiations => _levels['negotiations']!;
  LSW1LevelMinikitsController get invasionOfNaboo => _levels['invasionOfNaboo']!;
  LSW1LevelMinikitsController get escapeFromNaboo => _levels['escapeFromNaboo']!;
  LSW1LevelMinikitsController get mosEspaPodrace => _levels['mosEspaPodrace']!;
  LSW1LevelMinikitsController get retakeTheedPalace => _levels['retakeTheedPalace']!;
  LSW1LevelMinikitsController get darthMaul => _levels['darthMaul']!;
  LSW1LevelMinikitsController get discoveryOnKamino => _levels['discoveryOnKamino']!;
  LSW1LevelMinikitsController get droidFactory => _levels['droidFactory']!;
  LSW1LevelMinikitsController get jediBattle => _levels['jediBattle']!;
  LSW1LevelMinikitsController get gunshipCalvary => _levels['gunshipCalvary']!;
  LSW1LevelMinikitsController get countDooku => _levels['countDooku']!;
  LSW1LevelMinikitsController get battleOverCoruscant => _levels['battleOverCoruscant']!;
  LSW1LevelMinikitsController get chancellorInPeril => _levels['chancellorInPeril']!;
  LSW1LevelMinikitsController get generalGrievous => _levels['generalGrievous']!;
  LSW1LevelMinikitsController get defenseOfKashyyyk => _levels['defenseOfKashyyyk']!;
  LSW1LevelMinikitsController get ruinOfTheJedi => _levels['ruinOfTheJedi']!;
  LSW1LevelMinikitsController get darthVader => _levels['darthVader']!;

  final Map<String, LSW1LevelMinikitsController> _levels = {};
}

class LSW1LevelMinikitsController extends TTChildController {
  LSW1LevelMinikitsController({required super.parent, required List<(int, int)> sections}) {
    assert(_totals10(sections), 'Total number of minikit bits don\'t add to 10');
    _initializeChildren(sectionData: sections);
  }

  void _initializeChildren({required List<(int, int)> sectionData}) {
    var total = 0;
    for (final section in sectionData) {
      _sections.add(TTBitmapController(
        section.$1,
        parent: this,
        bitLength: section.$2,
      ));
      total += section.$2;
      _runningTotals.add(total);
    }
  }

  @override
  List<TTChildController> get children => _sections;

  // API

  /// The controller for the minikit section in the level. 1-indexed.
  TTBitmapController section(int index) {
    index = index - 1;
    assert(index >= 0 && index < _sections.length, 'Invalid index $index for section');
    return _sections[index];
  }

  /// Whether the given minikit has been collected in the level. Range: 1-10.
  bool minikitCollected(int number) {
    _assertValidMinikitNumber(number);
    var (section, bit) = _bitForMinikit(number);
    return _sections[section].bit(bit);
  }

  void collectMinikit(int number) {
    _assertValidMinikitNumber(number);
    var (section, bit) = _bitForMinikit(number);
    _sections[section].setBit(bit);
  }

  void uncollectMinikit(int number) {
    _assertValidMinikitNumber(number);
    var (section, bit) = _bitForMinikit(number);
    _sections[section].unsetBit(bit);
  }

  /// Total number of minikits collected. Each section's total will be capped
  /// at its bit length, forcing a maximum of 10.
  int totalMinikitsCollected() => _sections.fold(
        0,
        (runningTotal, section) => runningTotal + section.totalBitsSet(),
      );

  /// Helper method - whether all minikits are collected
  bool allMinikitsCollected() => totalMinikitsCollected() == 10;

  // Private API

  bool _totals10(List<(int, int)> sectionInfo) =>
      sectionInfo.fold<int>(0, (runningTotal, element) => runningTotal + element.$2) == 10;

  /// Takes a minikit number (1-10) and translates it to which section and bit
  /// the minikit resides in
  (int byte, int bit) _bitForMinikit(int number) {
    var index = _runningTotals.indexWhere((e) => e >= number);
    var bit = (index == 0 ? number : number - _runningTotals[index - 1]) - 1;
    return (index, bit);
  }

  void _assertValidMinikitNumber(int number) {
    assert(number >= 1 && number <= 10, "Invalid number $number for minikit, should be 1-10");
  }

  final List<TTBitmapController> _sections = [];

  /// The total number of minikits in all sections up to and including
  /// the value's index
  final List<int> _runningTotals = [];
}

const kLevelMinikitsData = <String, List<(int offset, int bits)>>{
  'negotiations': [
    (0x14, 5),
    (0x16, 2),
    (0x18, 3),
  ],
  'invasionOfNaboo': [
    (0x20, 5),
    (0x22, 1),
    (0x24, 3),
    (0x26, 1),
  ],
  'escapeFromNaboo': [
    (0x32, 2),
    (0x34, 3),
    (0x36, 2),
    (0x38, 3),
  ],
  'mosEspaPodrace': [
    (0x46, 4),
    (0x48, 4),
    (0x4A, 2),
  ],
  'retakeTheedPalace': [
    (0x58, 2),
    (0x5A, 2),
    (0x5C, 2),
    (0x5E, 1),
    (0x60, 1),
    (0x62, 2),
  ],
  'darthMaul': [
    (0x6A, 2),
    (0x6C, 3),
    (0x6E, 2),
    (0x72, 3),
  ],
  'discoveryOnKamino': [
    (0x7C, 2),
    (0x7E, 3),
    (0x80, 3),
    (0x82, 1),
    (0x84, 1),
  ],
  'droidFactory': [
    (0x92, 1),
    (0x94, 2),
    (0x96, 2),
    (0x98, 1),
    (0x9A, 3),
    (0x9C, 1),
  ],
  'jediBattle': [
    (0xA2, 10),
  ],
  'gunshipCalvary': [
    (0xA8, 5),
    (0xAA, 5),
  ],
  'countDooku': [
    (0xB0, 6),
    (0xB2, 4),
  ],
  'battleOverCoruscant': [
    (0xBC, 10),
  ],
  'chancellorInPeril': [
    (0xC0, 1),
    (0xC2, 4),
    (0xC4, 1),
    (0xC8, 1),
    (0xCA, 2),
    (0xCC, 1),
  ],
  'generalGrievous': [
    (0xD4, 10),
  ],
  'defenseOfKashyyyk': [
    (0xD8, 3),
    (0xDA, 3),
    (0xDC, 1),
    (0xDE, 3),
  ],
  'ruinOfTheJedi': [
    (0xE6, 3),
    (0xE8, 3),
    (0xEA, 4),
  ],
  'darthVader': [
    (0xF0, 5),
    (0xF2, 2),
    (0xF4, 3),
  ],
};
