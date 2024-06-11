import 'package:tt_save_editor/model/_core/controller/tt_value_controllers.dart';
import 'package:tt_save_editor/model/_core/tt_save_file.dart';

/// The baseline way to modify anything in the model.
sealed class TTController {
  /// The save file controller accessible by this controller
  TTSaveFileController get saveData;

  /// Saves changes. Default is to have all children save their changes.
  void saveChanges() {
    for (var c in children) {
      c.saveChanges();
    }
    _ensureClean();
  }

  /// Cancels changes. Default is to have all children cancel their changes.
  void cancelChanges() {
    for (var c in children) {
      c.cancelChanges();
    }
    _ensureClean();
  }

  /// Whether any of this controller's [children] are dirty
  bool anyChildrenDirty() {
    for (var c in children) {
      if (c.isDirty) return true;
    }
    return false;
  }

  void _ensureClean() {
    if (isDirty) throw StateError('This controller is still dirty after saving changes');
  }

  bool get isDirty;

  /// All [TTController]s will have a list of children, even if empty, which will
  /// be used for certain base-level operations like recursive saving and cancelling.
  List<TTChildController> get children;
}

/// A [TTController] which itself is a child, requiring a parent to complete
/// its operations.
abstract class TTChildController extends TTController {
  TTChildController({required this.parent});

  /// We are a child, so we ask our parent for our [saveData]. This should trace
  /// the parent hierarchy until reaching a [TTSaveFileController].
  @override
  TTSaveFileController get saveData => parent.saveData;

  /// We are dirty if any of our children are dirty.
  @override
  bool get isDirty => anyChildrenDirty();

  TTSaveFile get saveFile => saveData.saveFile;

  final TTController parent;
}

/// A controller responsible for holding the save file.
///
/// This will be required at the top of the controller hierarchy, as
/// every other controller will need a parent.
abstract class TTSaveFileController extends TTController {
  TTSaveFileController({required this.saveFile});

  /// We are the [saveData].
  @override
  TTSaveFileController get saveData => this;

  /// Saves changes: children, with additional overhead of recalculating our checksum and
  /// writing our save file to disk.
  @override
  void saveChanges() {
    for (var c in children) {
      c.saveChanges();
    }
    recalculateChecksum();
    checksumController.saveChanges();
    _ensureClean();
    saveFile.writeFileToDisk();
  }

  /// We are dirty also if our checksum controller is also dirty
  @override
  bool get isDirty => anyChildrenDirty() || checksumController.isDirty;

  /// The current checksum on the [saveFile]. Note that any pending changes will
  /// not be reflected in this value, as the checksum must be recalculated after
  /// all other changes are saved.
  int get checksum => checksumController.value;
  void setChecksum(int newValue) => checksumController.value = newValue;

  /// Will set the checksum controller value to the checksum of the current
  /// [saveFile]. This will not include any new changes.
  void recalculateChecksum({bool expectMatch = false}) {
    var sum = calculateChecksum();
    if (expectMatch && sum != checksumController.value) {
      throw StateError('Checksum mismatch: '
          '0x${sum.toRadixString(16)} versus '
          '0x${checksumController.value.toRadixString(16)}');
    }
    setChecksum(sum);
  }

  /// Algorithm to produce a checksum. Used internally while saving changes.
  int calculateChecksum();

  /// The save file object itself, as opposed to the [saveData] controller.
  final TTSaveFile saveFile;

  late final TTUint32Controller checksumController;
}
