import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/Notifiers/notes_notifier.dart';
import 'package:notebook/modules/document.dart';
import 'package:notebook/modules/helpers.dart';
import 'package:notebook/modules/onhovers.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final notesNotifier = ref.read(notesProvider.notifier);
    final fontFamily = ref.watch(fontFamilyProvider);

    double pageWidth = UIHelpers.pageWidth(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(20, 210, 200, 200),
          appBar: AppBar(title: const Text('Notes')),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child:
                        notes.isEmpty
                            ? const Center(child: Text('No notes yet'))
                            : ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final doc = notes[index];
                                return Dismissible(
                                  key: Key(doc.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (_) {
                                    notesNotifier.deleteNote(doc);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Deleted "${doc.title}"',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: HoverText(
                                      text: doc.title,
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // regular color
                                      ),
                                      hoverStyle: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue, // hover color
                                      ),
                                    ),

                                    subtitle: Text(
                                      doc.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: fontFamily),
                                    ),
                                    trailing: Text(
                                      '${doc.createdAt?.day}/${doc.createdAt?.month}/${doc.createdAt!.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                    onTap: () async {
                                      final editedNote =
                                          await _showEditNoteDialog(
                                            context,
                                            doc,
                                          );
                                      if (editedNote != null) {
                                        notesNotifier.updateNote(editedNote);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () async {
                    final newNote = await _showAddNoteDialog(context);
                    if (newNote != null) {
                      notesNotifier.addNote(newNote);
                    }
                  },
                  label: Text(
                    'Add Note',
                    style: TextStyle(fontFamily: fontFamily),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          // top: pageHeight * 0.01,
          left: pageWidth * 0.7,
          child: SizedBox(
            // width: pageWidth * 0.05,
            // height: pageWidth * 0.05,
            child: IconButton(
              icon: const Icon(Icons.font_download),
              tooltip: 'Select Font',
              onPressed: () => _showFontPickerDialog(context, ref),
            ),
          ),
        ),
      ],
    );
  }

  Future<Document?> _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return showDialog<Document>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final note = Document(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      content: content,
                      createdAt: DateTime.now(),
                    );
                    Navigator.of(context).pop(note);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Future<Document?> _showEditNoteDialog(BuildContext context, Document doc) {
    final titleController = TextEditingController(text: doc.title);
    final contentController = TextEditingController(text: doc.content);

    return showDialog<Document>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final updatedNote = Document(
                      id: doc.id,
                      title: title,
                      content: content,
                      createdAt: doc.createdAt,
                    );
                    Navigator.of(context).pop(updatedNote);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  // You can add the font picker dialog here if you haven't yet:
  Future<void> _showFontPickerDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    const availableFonts = [
      // 'Tahoma',
      'FiraCode',
      'Piazzolla',
      'Technology',
      'GreatVibes',
      'tahoma',
    ];

    final chosenFont = await showDialog<String>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text('Select Font'),
            children:
                availableFonts.map((font) {
                  return SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, font),
                    child: Text(font, style: TextStyle(fontFamily: font)),
                  );
                }).toList(),
          ),
    );

    if (chosenFont != null) {
      ref.read(fontFamilyProvider.notifier).state = chosenFont;
    }
  }
}
