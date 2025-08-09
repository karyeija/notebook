// notebook/lib/Notifiers/notes_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/hive/hive_functions.dart';
import 'package:notebook/modules/document.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Document>>((
  ref,
) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<Document>> {
  static const String boxName = 'notesBox';
  Box? _box;

  NotesNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await HiveFunctions.openBox(boxName);
    await loadNotes();
  }

  Future<void> loadNotes() async {
    // Ensure box is open
    _box ??= await HiveFunctions.openBox(boxName);
    final docs =
        _box!.values
            .map((e) => Document.fromMap(Map<dynamic, dynamic>.from(e)))
            .toList();
    // Update state with loaded documents
    state = docs;
  }

  Future<void> addNote(Document note) async {
    _box ??= await HiveFunctions.openBox(boxName);
    await _box!.put(note.id, note.toMap());
    state = [...state, note];
  }

  Future<void> updateNote(Document note) async {
    _box ??= await HiveFunctions.openBox(boxName);
    if (_box!.containsKey(note.id)) {
      await _box!.put(note.id, note.toMap());
      // Replace updated note in state list
      state = [
        for (final item in state)
          if (item.id == note.id) note else item,
      ];
    }
  }

  Future<void> deleteNote(Document note) async {
    _box ??= await HiveFunctions.openBox(boxName);
    if (_box!.containsKey(note.id)) {
      await _box!.delete(note.id);
      // Remove deleted note from state list
      state = state.where((item) => item.id != note.id).toList();
    }
  }
}

// Font family provider and notifier

final fontFamilyProvider = StateNotifierProvider<FontFamilyNotifier, String>((
  ref,
) {
  return FontFamilyNotifier();
});

class FontFamilyNotifier extends StateNotifier<String> {
  static const String _boxName = 'settingsBox';
  static const String _fontKey = 'fontFamily';

  late Box _box;

  FontFamilyNotifier() : super('Tahoma') {
    _loadFont();
  }

  Future<void> _loadFont() async {
    _box = await HiveFunctions.openBox(_boxName);
    final savedFont = _box.get(_fontKey);
    if (savedFont != null && savedFont is String) {
      state = savedFont;
    }
  }

  Future<void> setFontFamily(String font) async {
    state = font;
    await _box.put(_fontKey, font);
  }
}
