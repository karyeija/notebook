import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/Notifiers/notes_notifier.dart';
import 'package:notebook/hive/hive_functions.dart';
import 'package:notebook/modules/helpers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Local variable to store hive data
  List myHiveData = [];

  // Controllers for TextFields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Control form visibility and editing key
  bool _showForm = false;
  int? _editingKey;

  // Variables for detail view
  bool _showDetail = false;
  Map<String, dynamic>? _selectedUserDetail;

  // Fetch Hive data and refresh UI
  void getHiveData() {
    myHiveData = HiveFunctions.getAllUsers();
    setState(() {});
  }

  // Open form for new or edit
  void openForm(int? itemKey) {
    _editingKey = itemKey;

    if (itemKey != null) {
      final existingItem = myHiveData.firstWhere(
        (element) => element['key'] == itemKey,
      );
      _titleController.text = existingItem['Title'];
      _contentController.text = existingItem['content'];
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    setState(() {
      _showForm = true;
    });
  }

  // Close form and clear controllers
  void closeForm() {
    _titleController.clear();
    _contentController.clear();

    setState(() {
      _showForm = false;
      _editingKey = null;
    });
  }

  @override
  void initState() {
    super.initState();
    getHiveData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = UIHelpers.pageWidth(context);

    // var pageHeight = UIHelpers.pageHeight(context);
    var fontFamily = ref.watch(fontFamilyProvider);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text("Notes"),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text("Add Data"),
              onPressed: () => openForm(null),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    myHiveData.isEmpty
                        ? const Center(
                          child: Text(
                            "No Data is Stored",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        : Column(
                          children: List.generate(myHiveData.length, (index) {
                            final userData = myHiveData[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  "Title : ${userData["Title"].toString().toUpperCase()}",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                subtitle: Text(
                                  "Content : ${userData["content"]}",
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:
                                          () => openForm(userData["key"]),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        HiveFunctions.deleteUser(
                                          userData["key"],
                                        );
                                        getHiveData();
                                      },
                                    ),
                                    // inside ListTile trailing:
                                    IconButton(
                                      icon: const Icon(Icons.read_more_rounded),
                                      color: Colors.blue,
                                      onPressed: () {
                                        final userDetail =
                                            HiveFunctions.getUser(
                                              userData["key"],
                                            );
                                        setState(() {
                                          _selectedUserDetail =
                                              userDetail
                                                  ?.cast<String, dynamic>();
                                          _showDetail = userDetail != null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
              ),
            ),
          ),
          Positioned(
            // top: pageHeight * 0.01,
            left: pageWidth * 0.6,
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

          // Positioned refresh button
          Positioned(
            left: pageWidth * 0.7,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: getHiveData,
            ),
          ),

          // Overlay detail container
          if (showDetails && _selectedUserDetail != null)
            Positioned.fill(
              child: Container(
                // height: pageHeight * 0.8,
                color: Colors.black54, // semi-transparent background
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _selectedUserDetail!["Title"] ?? "No Title",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedUserDetail!["content"] ?? "No Content",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: fontFamily,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showDetail = false;
                                _selectedUserDetail = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Overlay form container
          if (_showForm)
            Positioned.fill(
              child: Container(
                // height: pageHeight * 0.8,
                color: Colors.black54, // semi-transparent background
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _editingKey == null ? 'Create New' : 'Update',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          maxLines: 5,
                          controller: _contentController,
                          // keyboardType: TextInputType.contentAddress,
                          decoration: const InputDecoration(
                            hintText: 'Content',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                closeForm();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // Basic validation check
                                if (_titleController.text.trim().isEmpty ||
                                    _contentController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter both title and content',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (_editingKey == null) {
                                  HiveFunctions.createUser({
                                    "Title": _titleController.text.trim(),
                                    "content": _contentController.text.trim(),
                                    "createdAt": DateTime.now(),
                                  });
                                } else {
                                  HiveFunctions.updateUser(_editingKey!, {
                                    "Title": _titleController.text.trim(),
                                    "content": _contentController.text.trim(),
                                    "createdAt": DateTime.now(),
                                  });
                                }
                                closeForm();
                                getHiveData();
                              },
                              child: Text(
                                _editingKey == null ? 'Create New' : 'Update',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get showDetails => _showDetail;
}

// You can add the font picker dialog here if you haven't yet:
Future<void> _showFontPickerDialog(BuildContext context, WidgetRef ref) async {
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
