import 'package:test/test.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_levels.dart';
import 'package:tt_save_editor/model/lsw1/lsw1_save_file.dart';

void main() async {
  late LSW1SaveFile saveFile;
  late LSW1LevelsController controller;

  setUp(() {
    saveFile = LSW1SaveFile.blank();
    var saveFileController = LSW1SaveFileController(saveFile: saveFile)..initializeSaveFile();
    controller = saveFileController.levels;
  });

  test('Correct behavior - unlocking/locking levels', () {
    expect(controller.negotiations.unlocked, isTrue);
    expect(controller.invasionOfNaboo.unlocked, isFalse);
    controller.invasionOfNaboo.unlock();
    controller.escapeFromNaboo.unlock();
    expect(controller.isDirty, isTrue);
    expect(controller.invasionOfNaboo.unlocked, isTrue);
    expect(controller.escapeFromNaboo.unlocked, isTrue);
    controller.escapeFromNaboo.lock();
    expect(controller.isDirty, isTrue);
    expect(controller.escapeFromNaboo.unlocked, isFalse);
  });

  test('Correct behavior - completing/uncompleting levels', () {
    expect(controller.negotiations.completed, isFalse);
    controller.negotiations.complete();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.completed, isTrue);
    controller.negotiations.uncomplete();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.completed, isFalse);
  });

  test('Correct behavior - obtaining/unobtaining superkit', () {
    expect(controller.negotiations.superkitObtained, isFalse);
    controller.negotiations.obtainSuperkit();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.superkitObtained, isTrue);
    controller.negotiations.unobtainSuperkit();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.superkitObtained, isFalse);
  });

  test('Correct behavior - obtaining/unobtaining minikit', () {
    expect(controller.negotiations.minikitObtained, isFalse);
    controller.negotiations.obtainMinikit();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.minikitObtained, isTrue);
    controller.negotiations.unobtainMinikit();
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.minikitObtained, isFalse);
  });

  test('Correct behavior - setting minikit count', () {
    expect(controller.negotiations.minikitObtained, isFalse);
    controller.negotiations.setMinikitCount(8);
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.minikitObtained, isFalse);
    expect(controller.negotiations.minikitCount, equals(8));
    controller.negotiations.setMinikitCount(10);
    expect(controller.negotiations.minikitObtained, isFalse);
    expect(controller.negotiations.minikitCount, equals(10));
    controller.negotiations.setMinikitCount(0);
    expect(controller.isDirty, isTrue);
    expect(controller.negotiations.minikitCount, isZero);
  });
}
