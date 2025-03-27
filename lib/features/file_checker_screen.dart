import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileCheckerScreen extends StatefulWidget {
  @override
  _FileCheckerScreenState createState() => _FileCheckerScreenState();
}

class _FileCheckerScreenState extends State<FileCheckerScreen> {
  String? _fileName;
  String? _fileContent;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileContent = String.fromCharCodes(result.files.single.bytes!);
      });
    }
  }

  void _checkFile() {
    // Implement file checking logic here
    print('File checked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fileName == null
                ? Text('No file selected.')
                : Text('File: $_fileName'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkFile,
              child: Text('Check File'),
            ),
            if (_fileContent != null) ...[
              SizedBox(height: 20),
              Text('File Content: $_fileContent'),
            ],
          ],
        ),
      ),
    );
  }
}