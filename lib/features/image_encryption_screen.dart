import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';

class ImageEncryptionScreen extends StatefulWidget {
  @override
  _ImageEncryptionScreenState createState() => _ImageEncryptionScreenState();
}

class _ImageEncryptionScreenState extends State<ImageEncryptionScreen> {
  File? _image;
  Uint8List? _webImage;
  String? _imageName;
  String? _encryptedImage;
  String? _statusMessage;
  String? _hiddenText;
  TextEditingController _hiddenTextController = TextEditingController();
  bool _isLoading = false;

  final _key = encrypt.Key.fromUtf8('my 32 length key................');
  final _iv = encrypt.IV.fromLength(16);
  late final encrypt.Encrypter _encrypter;

  @override
  void initState() {
    super.initState();
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _webImage = imageBytes;
        _imageName = pickedFile.name;
        _statusMessage = 'Image selected: $_imageName';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _statusMessage = 'No image selected.';
      });
    }
  }

  Future<void> _encryptImage() async {
    if (_webImage != null) {
      setState(() {
        _isLoading = true;
      });
      final hiddenTextBytes = utf8.encode(_hiddenTextController.text);
      final combinedBytes = Uint8List.fromList([..._webImage!, ...hiddenTextBytes]);
      final encrypted = _encrypter.encryptBytes(combinedBytes, iv: _iv);
      setState(() {
        _encryptedImage = encrypted.base64;
        _statusMessage = 'Image encrypted successfully.';
        _isLoading = false;
      });
    }
  }

  Future<void> _decryptImage() async {
    if (_encryptedImage != null) {
      setState(() {
        _isLoading = true;
      });
      final encryptedBytes = base64.decode(_encryptedImage!);
      final decrypted = _encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: _iv);
      final hiddenTextLength = utf8.encode(_hiddenTextController.text).length;
      final imageBytes = decrypted.sublist(0, decrypted.length - hiddenTextLength);
      final hiddenTextBytes = decrypted.sublist(decrypted.length - hiddenTextLength);
      final hiddenText = utf8.decode(hiddenTextBytes);
      setState(() {
        _webImage = Uint8List.fromList(imageBytes);
        _hiddenText = hiddenText;
        _statusMessage = 'Image decrypted successfully. Hidden text: $hiddenText';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadEncryptedData() async {
    if (_encryptedImage != null) {
      final blob = html.Blob([_encryptedImage!], 'text/plain', 'native');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'encrypted_image.txt')
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }

  Future<void> _uploadEncryptedData() async {
    setState(() {
      _isLoading = true;
    });
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final encryptedData = await pickedFile.readAsString();
      setState(() {
        _encryptedImage = encryptedData;
        _statusMessage = 'Encrypted image uploaded successfully.';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _statusMessage = 'No file selected.';
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
  }

  Widget _buildOutputBox(String? text, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: text != null ? () => _copyToClipboard(text) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Encryption'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                CircularProgressIndicator()
              else ...[
                if (_webImage == null)
                  Text('No image selected.')
                else
                  Image.memory(_webImage!),
                SizedBox(height: 20),
                if (_imageName != null)
                  Text('Selected Image: $_imageName'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _hiddenTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter hidden text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _encryptImage,
                  child: Text('Encrypt Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _decryptImage,
                  child: Text('Decrypt Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _downloadEncryptedData,
                  child: Text('Download Encrypted Data'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadEncryptedData,
                  child: Text('Upload Encrypted Data'),
                ),
                SizedBox(height: 20),
                if (_statusMessage != null)
                  Text(_statusMessage!),
                if (_encryptedImage != null)
                  _buildOutputBox(_encryptedImage, 'Encrypted Image Data'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}