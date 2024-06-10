import 'package:test/test.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_save_file.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_shop.dart';

void main() async {
  late LSW1SaveFile saveFile;
  late LSW1ShopController controller;

  setUp(() {
    saveFile = LSW1SaveFile.blank();
    var saveFileController = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    controller = saveFileController.shop;
  });

  test('Correct behavior - buying hints', () {
    var hintsController = controller.hintsPurchasedController;
    expect(controller.hintPurchased(1), isFalse);
    expect(hintsController.bitLength, equals(13));
    expect(hintsController.totalBitsSet(), isZero);
    controller.purchaseHint(1);
    expect(controller.isDirty, isTrue);
    expect(controller.hintPurchased(1), isTrue);
    expect(hintsController.bit(5), isTrue);
    expect(hintsController.totalBitsSet(), equals(1));
    controller.purchaseHint(8);
    controller.unpurchaseHint(1);
    expect(controller.isDirty, isTrue);
    expect(controller.hintPurchased(1), isFalse);
    expect(controller.hintPurchased(8), isTrue);
    expect(hintsController.bit(5), isFalse);
    expect(hintsController.bit(12), isTrue);
    expect(hintsController.totalBitsSet(), equals(1));
  });

  test('Correct behavior - invalid hint purchasing values', () {
    expect(() => controller.hintPurchased(-1), throwsA(isRangeError));
    expect(() => controller.hintPurchased(0), throwsA(isRangeError));
    expect(() => controller.hintPurchased(9), throwsA(isRangeError));
    expect(() => controller.purchaseHint(-1), throwsA(isRangeError));
    expect(() => controller.purchaseHint(0), throwsA(isRangeError));
    expect(() => controller.purchaseHint(9), throwsA(isRangeError));
    expect(() => controller.unpurchaseHint(-1), throwsA(isRangeError));
    expect(() => controller.unpurchaseHint(0), throwsA(isRangeError));
    expect(() => controller.unpurchaseHint(9), throwsA(isRangeError));
  });

  test('Correct behavior - buying characters', () {
    var charsController = controller.charactersPurchasedController;
    expect(controller.characterPurchased('gonkDroid'), isFalse);
    expect(controller.characterUnlocked('gonkDroid'), isFalse);
    expect(charsController.bitLength, equals(31));
    expect(charsController.totalBitsSet(), isZero);
    controller.purchaseCharacter('gonkDroid');
    expect(controller.isDirty, isTrue);
    expect(controller.characterPurchased('gonkDroid'), isTrue);
    expect(controller.characterUnlocked('gonkDroid'), isFalse);
    expect(charsController.bit(0), isTrue);
    expect(charsController.totalBitsSet(), equals(1));
    controller.purchaseCharacter('pkDroid');
    controller.unpurchaseCharacter('gonkDroid');
    expect(controller.isDirty, isTrue);
    expect(controller.characterPurchased('gonkDroid'), isFalse);
    expect(controller.characterUnlocked('gonkDroid'), isFalse);
    expect(controller.characterPurchased('pkDroid'), isTrue);
    expect(charsController.bit(0), isFalse);
    expect(charsController.bit(1), isTrue);
    expect(charsController.totalBitsSet(), equals(1));
  });

  test('Correct behavior - invalid character purchasing values', () {
    expect(() => controller.characterPurchased('notACharacter'), throwsA(isArgumentError));
    expect(() => controller.purchaseCharacter('notACharacter'), throwsA(isArgumentError));
    expect(() => controller.unpurchaseCharacter('notACharacter'), throwsA(isArgumentError));
  });

  test('Correct behavior - buying extras', () {
    var extrasController = controller.extrasPurchasedController;
    expect(controller.extraPurchased('invincibility'), isFalse);
    expect(controller.extraUnlocked('invincibility'), isFalse);
    expect(extrasController.bitLength, equals(10));
    expect(extrasController.totalBitsSet(), isZero);
    controller.purchaseExtra('invincibility');
    expect(controller.isDirty, isTrue);
    expect(controller.extraPurchased('invincibility'), isTrue);
    expect(controller.extraUnlocked('invincibility'), isFalse);
    expect(extrasController.bit(0), isTrue);
    expect(extrasController.totalBitsSet(), equals(1));
    controller.purchaseExtra('silhouettes');
    controller.unpurchaseExtra('invincibility');
    expect(controller.isDirty, isTrue);
    expect(controller.extraPurchased('invincibility'), isFalse);
    expect(controller.extraUnlocked('invincibility'), isFalse);
    expect(controller.extraPurchased('silhouettes'), isTrue);
    expect(extrasController.bit(0), isFalse);
    expect(extrasController.bit(1), isTrue);
    expect(extrasController.totalBitsSet(), equals(1));
  });

  test('Correct behavior - invalid extra purchasing values', () {
    expect(() => controller.extraPurchased('notAnExtra'), throwsA(isArgumentError));
    expect(() => controller.purchaseExtra('notAnExtra'), throwsA(isArgumentError));
    expect(() => controller.unpurchaseExtra('notAnExtra'), throwsA(isArgumentError));
  });

  test('Correct behavior - unlocking characters', () {
    var charsController = controller.charactersUnlockedController;
    expect(controller.characterPurchased('clone'), isFalse);
    expect(controller.characterUnlocked('clone'), isFalse);
    expect(charsController.totalBitsSet(), equals(2)); // Qui-Gon and Obi-Wan
    controller.unlockCharacter('clone');
    expect(controller.isDirty, isTrue);
    expect(controller.characterPurchased('clone'), isFalse);
    expect(controller.characterUnlocked('clone'), isTrue);
    expect(charsController.bit(0), isTrue);
    expect(charsController.totalBitsSet(), equals(3));
    controller.unlockCharacter('droideka');
    controller.lockCharacter('clone');
    expect(controller.isDirty, isTrue);
    expect(controller.characterPurchased('clone'), isFalse);
    expect(controller.characterUnlocked('clone'), isFalse);
    expect(controller.characterUnlocked('droideka'), isTrue);
    expect(charsController.bit(0), isFalse);
    expect(charsController.bit(1), isTrue);
    expect(charsController.totalBitsSet(), equals(3));
  });

  test('Correct behavior - invalid character unlocking values', () {
    expect(() => controller.characterUnlocked('notACharacter'), throwsA(isArgumentError));
    expect(() => controller.unlockCharacter('notACharacter'), throwsA(isArgumentError));
    expect(() => controller.lockCharacter('notACharacter'), throwsA(isArgumentError));
  });

  test('Correct behavior - unlocking extras', () {
    var extrasController = controller.extrasUnlockedController;
    expect(controller.extraPurchased('invincibility'), isFalse);
    expect(controller.extraUnlocked('invincibility'), isFalse);
    expect(extrasController.bitLength, equals(10));
    expect(extrasController.totalBitsSet(), isZero);
    controller.unlockExtra('invincibility');
    expect(controller.isDirty, isTrue);
    expect(controller.extraPurchased('invincibility'), isFalse);
    expect(controller.extraUnlocked('invincibility'), isTrue);
    expect(extrasController.bit(0), isTrue);
    expect(extrasController.totalBitsSet(), equals(1));
    controller.unlockExtra('silhouettes');
    controller.lockExtra('invincibility');
    expect(controller.isDirty, isTrue);
    expect(controller.extraPurchased('invincibility'), isFalse);
    expect(controller.extraUnlocked('invincibility'), isFalse);
    expect(controller.extraUnlocked('silhouettes'), isTrue);
    expect(extrasController.bit(0), isFalse);
    expect(extrasController.bit(1), isTrue);
    expect(extrasController.totalBitsSet(), equals(1));
  });

  test('Correct behavior - invalid extra purchasing values', () {
    expect(() => controller.extraUnlocked('notAnExtra'), throwsA(isArgumentError));
    expect(() => controller.unlockExtra('notAnExtra'), throwsA(isArgumentError));
    expect(() => controller.lockExtra('notAnExtra'), throwsA(isArgumentError));
  });
}
