import 'package:flutter/material.dart';
import 'package:notebook/modules/document.dart';

Future<Document?> showEditNoteDialog(BuildContext context, Document doc) {
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
