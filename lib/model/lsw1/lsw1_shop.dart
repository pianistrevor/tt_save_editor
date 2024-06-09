import 'package:tt_save_editor/model/_core/controller/tt_controller.dart';
import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';

class LSW1ShopController extends TTChildController {
  LSW1ShopController({required super.parent}) {
    _initializeChildren();
  }

  void _initializeChildren() {
    hintsPurchasedController = TTBitmapController(0x1C0, parent: this, bitLength: 13);
    charactersPurchasedController = TTBitmapController(0x1C8, parent: this, bitLength: 31);
    extrasPurchasedController = TTBitmapController(0x1D0, parent: this, bitLength: 10);
    charactersUnlockedController = TTBitmapController(0x1D8, parent: this, bitLength: 126);
    extrasUnlockedController = TTBitmapController(0x200, parent: this, bitLength: 10);
  }

  @override
  List<TTChildController> get children => [
        hintsPurchasedController,
        charactersPurchasedController,
        extrasPurchasedController,
        charactersUnlockedController,
        extrasUnlockedController,
      ];

  // API

  /// Whether a given hint has been purchased.
  ///
  /// There are only 8 purchaseable hints so
  /// valid values are in the range 1-8. The rest should answer 0.
  bool hintPurchased(int whichHint) {
    _assertValidHintOffset(whichHint);
    return hintsPurchasedController.bit(whichHint + 4);
  }

  void purchaseHint(int whichHint) {
    _assertValidHintOffset(whichHint);
    hintsPurchasedController.setBit(whichHint + 4);
  }

  void unpurchaseHint(int whichHint) {
    _assertValidHintOffset(whichHint);
    hintsPurchasedController.unsetBit(whichHint + 4);
  }

  /// Whether the character with the given key has been purchased.
  ///
  /// These values are independent of whether the character is unlocked. This bit represents
  /// whether the shop token can be purchased.
  bool characterPurchased(String key) {
    int characterBit = _getCharacterPurchasedBitIfExisting(key);

    return charactersPurchasedController.bit(characterBit);
  }

  void purchaseCharacter(String key) {
    int characterBit = _getCharacterPurchasedBitIfExisting(key);

    charactersPurchasedController.setBit(characterBit);
  }

  void unpurchaseCharacter(String key) {
    int characterBit = _getCharacterPurchasedBitIfExisting(key);

    charactersPurchasedController.unsetBit(characterBit);
  }

  /// Whether the extra with the given key has been purchased.
  ///
  /// These values are independent of whether the extra is unlocked. This bit represents
  /// whether the shop token can be purchased, even if the extra is already unlocked.
  bool extraPurchased(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    return extrasPurchasedController.bit(extraBit);
  }

  void purchaseExtra(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    extrasPurchasedController.setBit(extraBit);
  }

  void unpurchaseExtra(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    extrasPurchasedController.unsetBit(extraBit);
  }

  /// Whether the character with the given key has been unlocked.
  ///
  /// These values are independent of whether the character is purchased, and include
  /// values for characters which are obtained through normal story events rather than
  /// the shop. This bit represents whether the character shows up in the character
  /// selection screen.
  bool characterUnlocked(String key) {
    int characterBit = _getCharacterUnlockedBitIfExisting(key);

    return charactersUnlockedController.bit(characterBit);
  }

  void unlockCharacter(String key) {
    int characterBit = _getCharacterUnlockedBitIfExisting(key);

    charactersUnlockedController.setBit(characterBit);
  }

  void lockCharacter(String key) {
    int characterBit = _getCharacterUnlockedBitIfExisting(key);

    charactersUnlockedController.unsetBit(characterBit);
  }

  /// Whether the extra with the given key has been unlocked.
  ///
  /// These values are independent of whether the extra is purchased. This bit represents
  /// whether the extra shows togglable in the extras menu. If the purchased bit is set, this
  /// bit will automatically be set upon loading the game.
  bool extraUnlocked(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    return extrasUnlockedController.bit(extraBit);
  }

  void unlockExtra(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    extrasUnlockedController.setBit(extraBit);
  }

  void lockExtra(String key) {
    int extraBit = _getExtrasBitIfExisting(key);

    extrasUnlockedController.unsetBit(extraBit);
  }

  // Private API
  int _getCharacterPurchasedBitIfExisting(String key) {
    if (!kCharacterPurchasedBits.containsKey(key)) {
      throw Exception('No shop character called $key!');
    }
    return kCharacterPurchasedBits[key]!;
  }

  int _getExtrasBitIfExisting(String key) {
    if (!kExtrasBits.containsKey(key)) throw Exception('No shop extra called $key!');
    return kExtrasBits[key]!;
  }

  int _getCharacterUnlockedBitIfExisting(String key) {
    if (!kCharacterUnlockedBits.containsKey(key)) throw Exception('No character called $key!');
    return kCharacterUnlockedBits[key]!;
  }

  void _assertValidHintOffset(int offset) {
    assert(offset > 0 && offset < 9, 'Invalid hint number: $offset');
  }

  late final TTBitmapController hintsPurchasedController;
  late final TTBitmapController charactersPurchasedController;
  late final TTBitmapController extrasPurchasedController;
  late final TTBitmapController charactersUnlockedController;
  late final TTBitmapController extrasUnlockedController;
}

const kCharacterPurchasedBits = <String, int>{
  'gonkDroid': 0,
  'pkDroid': 1,
  'battleDroidSecurity': 2,
  'battleDroid': 3,
  'battleDroidCommander': 4,
  'droideka': 5,
  'royalGuard': 6,
  'padme': 7,
  'darthMaul': 8,
  'clone': 9,
  'geonosian': 10,
  'battelDroidGeonosis': 11,
  'superBattleDroid': 12,
  'jangoFett': 13,
  'bobaFett': 14,
  'luminara': 15,
  'kiAdiMundi': 16,
  'kitFisto': 17,
  'shaakTi': 18,
  'countDooku': 19,
  'grievousBodyguard': 20,
  'generalGrievous': 21,
  'cloneEpisodeIII': 22,
  'cloneEpisodeIIIPilot': 23,
  'cloneEpisodeIIISwamp': 24,
  'cloneEpisodeIIIWalker': 25,
  'maceWinduEpisodeIII': 26,
  'disguisedClone': 27,
  'darthSidious': 28,
  'rebelTrooper': 29,
  'princessLeia': 30,
};
const kExtrasBits = <String, int>{
  'invincibility': 0,
  'silhouettes': 1,
  'purple': 2,
  'mustaches': 3,
  'minikitDetector': 4,
  'teaCups': 5,
  'brushes': 6,
  'bigBlasters': 7,
  'classicBlasters': 8,
  'sillyBlasters': 9,
};
const kCharacterUnlockedBits = <String, int>{
  'clone': 0,
  'droideka': 1,
  'battleDroid': 2,
  'quiGonJinn': 3,
  'obiWanKenobi': 4,
  'obiWanKenobiJediMaster': 5,
  'darthSidious': 6,
  'jangoFett': 7,
  'darthMaul': 8,
  'jarJarBinks': 9,
  'r2d2': 10,
  'anakinSkywalkerPadawan': 13,
  'countDooku': 14,
  'yoda': 15,
  'royalGuard': 18,
  'anakinSkywalkerBoy': 19,
  'r4p17': 20,
  'padme': 21,
  'padmeClawed': 22,
  'padmeBattle': 23,
  'padmeGeonosis': 24,
  'queenAmidala': 25,
  'captainPanaka': 28,
  'c3po': 29,
  'tc14': 30,
  'rebelTrooper': 34,
  'maceWindu': 35,
  'pkDroid': 43,
  'bobaFett': 53,
  'superBattleDroid': 62,
  'battleDroidCommander': 63,
  'battleDroidSecurity': 64,
  'battleDroidGeonosis': 65,
  'geonosian': 67,
  'chewbacca': 72,
  'generalGrievous': 74,
  'anakinSkywalkerJedi': 75,
  'gonkDroid': 77,
  'anakinSkywalkerDarthVader': 78,
  'maceWinduEpisodeIII': 83,
  'stormtrooper': 95,
  'obiWanKenobiEpisodeIII': 97,
  'disguisedClone': 98,
  'wookiee': 99,
  'chancellorPalpatine': 100,
  'cloneEpisodeIII': 101,
  'cloneEpisodeIIIPilot': 102,
  'commanderCody': 103,
  'cloneEpisodeIIISwamp': 104,
  'cloneEpisodeIIIWalker': 105,
  'luminara': 109,
  'shaakTi': 110,
  'kiAdiMundi': 111,
  'kitFisto': 112,
  'grievousBodyguard': 113,
  'princessLeia': 125,
};
