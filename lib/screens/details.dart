          // // Overlay form container
          // if (_showForm)
          //   Positioned.fill(
          //     child: Container(
          //       // height: pageHeight * 0.8,
          //       color: Colors.black54, // semi-transparent background
          //       alignment: Alignment.center,
          //       child: Container(
          //         margin: const EdgeInsets.symmetric(horizontal: 10),
          //         padding: const EdgeInsets.all(16),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         child: SingleChildScrollView(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Center(
          //                 child: Text(
          //                   _editingKey == null ? 'Create New' : 'Update',
          //                   style: const TextStyle(
          //                     fontSize: 22,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(height: 10),
          //               TextField(
          //                 controller: _titleController,
          //                 decoration: const InputDecoration(
          //                   hintText: 'Title',
          //                   border: OutlineInputBorder(),
          //                 ),
          //               ),
          //               const SizedBox(height: 5),
          //               TextField(
          //                 maxLines: 5,
          //                 controller: _contentController,
          //                 // keyboardType: TextInputType.contentAddress,
          //                 decoration: const InputDecoration(
          //                   hintText: 'Content',
          //                   border: OutlineInputBorder(),
          //                 ),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   TextButton(
          //                     onPressed: () {
          //                       closeForm();
          //                     },
          //                     child: const Text('Cancel'),
          //                   ),
          //                   ElevatedButton(
          //                     style: ElevatedButton.styleFrom(
          //                       backgroundColor: Colors.green,
          //                       foregroundColor: Colors.white,
          //                     ),
          //                     onPressed: () {
          //                       // Basic validation check
          //                       if (_titleController.text.trim().isEmpty ||
          //                           _contentController.text.trim().isEmpty) {
          //                         ScaffoldMessenger.of(context).showSnackBar(
          //                           const SnackBar(
          //                             content: Text(
          //                               'Please enter both title and content',
          //                             ),
          //                           ),
          //                         );
          //                         return;
          //                       }

          //                       if (_editingKey == null) {
          //                         HiveFunctions.createUser({
          //                           "Title": _titleController.text.trim(),
          //                           "content": _contentController.text.trim(),
          //                         });
          //                       } else {
          //                         HiveFunctions.updateUser(_editingKey!, {
          //                           "Title": _titleController.text.trim(),
          //                           "content": _contentController.text.trim(),
          //                         });
          //                       }
          //                       closeForm();
          //                       getHiveData();
          //                     },
          //                     child: Text(
          //                       _editingKey == null ? 'Create New' : 'Update',
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),