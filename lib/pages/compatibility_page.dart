import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  State<CompatibilityPage> createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
  final List<PickedFile> _files = [];

  void _pickFile() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = '*/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files != null) {
        for (final file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoadEnd.listen((e) {
            final bytes = reader.result as Uint8List?;
            setState(() {
              _files.add(PickedFile(file.name, bytes));
            });
          });
        }
      }
    });
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        toolbarHeight: 50,
        automaticallyImplyLeading: true,
        title: const Text(
          "Compatibility Check",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Upload Files
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Upload Your Files'),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () => _removeFile(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// add Topics
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextField(
                autocorrect: true,
                // expands: true,
                minLines: 4,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Add Topics to Compare",
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Submit"),
        ),
      ),
    );
  }
}

class PickedFile {
  final String name;
  final Uint8List? bytes;

  PickedFile(this.name, this.bytes);
}
