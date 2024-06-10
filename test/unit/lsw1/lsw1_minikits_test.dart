import 'package:test/test.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_minikits.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_save_file.dart';

void main() async {
  late LSW1SaveFile saveFile;
  late LSW1MinikitsController controller;

  setUp(() {
    saveFile = LSW1SaveFile.blank();
    var saveFileController = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    controller = saveFileController.minikits;
  });

  test('Correct behavior - collecting minikits, Negotiations', () {
    var negotiations = controller.negotiations;
    expect(negotiations.totalMinikitsCollected(), isZero);
    expect(negotiations.section(1).bitLength, equals(5));
    negotiations.collectMinikit(1);
    expect(negotiations.isDirty, isTrue);
    expect(negotiations.minikitCollected(1), isTrue);
    expect(negotiations.totalMinikitsCollected(), equals(1));
    expect(negotiations.section(1).totalBitsSet(), equals(1));
    negotiations.collectMinikit(2);
    negotiations.collectMinikit(3);
    negotiations.collectMinikit(4);
    negotiations.collectMinikit(5);
    negotiations.collectMinikit(6);
    expect(negotiations.minikitCollected(5), isTrue);
    expect(negotiations.minikitCollected(6), isTrue);
    expect(negotiations.minikitCollected(7), isFalse);
    expect(negotiations.totalMinikitsCollected(), equals(6));
    expect(negotiations.section(1).totalBitsSet(), equals(5));
    expect(negotiations.section(2).totalBitsSet(), equals(1));
    negotiations.collectMinikit(7);
    negotiations.collectMinikit(8);
    negotiations.collectMinikit(9);
    negotiations.collectMinikit(10);
    expect(negotiations.minikitCollected(10), isTrue);
    expect(negotiations.totalMinikitsCollected(), equals(10));
    expect(negotiations.allMinikitsCollected(), isTrue);
    expect(negotiations.section(1).totalBitsSet(), equals(5));
    expect(negotiations.section(2).totalBitsSet(), equals(2));
    expect(negotiations.section(3).totalBitsSet(), equals(3));
    negotiations.saveChanges();
    expect(negotiations.isDirty, isFalse);
  });

  test('Correct behavior - uncollecting minikits, Invasion of Naboo', () {
    var invasionOfNaboo = controller.invasionOfNaboo;
    expect(invasionOfNaboo.totalMinikitsCollected(), isZero);
    invasionOfNaboo.collectMinikit(1);
    invasionOfNaboo.collectMinikit(2);
    expect(invasionOfNaboo.minikitCollected(1), isTrue);
    expect(invasionOfNaboo.minikitCollected(2), isTrue);
    expect(invasionOfNaboo.totalMinikitsCollected(), equals(2));
    expect(invasionOfNaboo.section(1).totalBitsSet(), equals(2));
    invasionOfNaboo.saveChanges();
    expect(invasionOfNaboo.isDirty, isFalse);
    invasionOfNaboo.uncollectMinikit(3); // does nothing
    expect(invasionOfNaboo.isDirty, isFalse);
    expect(invasionOfNaboo.minikitCollected(1), isTrue);
    expect(invasionOfNaboo.minikitCollected(2), isTrue);
    expect(invasionOfNaboo.totalMinikitsCollected(), equals(2));
    invasionOfNaboo.uncollectMinikit(2);
    expect(invasionOfNaboo.isDirty, isTrue);
    expect(invasionOfNaboo.minikitCollected(1), isTrue);
    expect(invasionOfNaboo.minikitCollected(2), isFalse);
    expect(invasionOfNaboo.totalMinikitsCollected(), equals(1));
    invasionOfNaboo.uncollectMinikit(1);
    expect(invasionOfNaboo.minikitCollected(1), isFalse);
    expect(invasionOfNaboo.minikitCollected(2), isFalse);
    expect(invasionOfNaboo.totalMinikitsCollected(), isZero);
    expect(invasionOfNaboo.section(1).totalBitsSet(), isZero);
    invasionOfNaboo.saveChanges();
    expect(invasionOfNaboo.isDirty, isFalse);
  });

  test('Correct behavior for 10-minikits section - Battle over Coruscant', () {
    var battleOverCoruscant = controller.battleOverCoruscant;
    // Collect all minikits
    for (int i = 1; i <= 10; ++i) {
      battleOverCoruscant.collectMinikit(i);
    }
    expect(battleOverCoruscant.minikitCollected(1), isTrue);
    expect(battleOverCoruscant.minikitCollected(10), isTrue);
    expect(battleOverCoruscant.totalMinikitsCollected(), equals(10));
    expect(battleOverCoruscant.allMinikitsCollected(), isTrue);
    expect(battleOverCoruscant.section(1).totalBitsSet(), equals(10));
  });

  test('Correct behavior for invalid values', () {
    var battleOverCoruscant = controller.battleOverCoruscant;
    expect(() => battleOverCoruscant.collectMinikit(0), throwsA(isArgumentError));
    expect(() => battleOverCoruscant.collectMinikit(11), throwsA(isArgumentError));
  });
}
