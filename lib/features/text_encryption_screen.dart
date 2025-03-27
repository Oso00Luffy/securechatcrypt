import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/text_encryption.dart';

class TextEncryptionScreen extends StatefulWidget {
  @override
  _TextEncryptionScreenState createState() => _TextEncryptionScreenState();
}

class _TextEncryptionScreenState extends State<TextEncryptionScreen> {
  TextEditingController _encryptController = TextEditingController();
  TextEditingController _decryptController = TextEditingController();
  String? _encryptedText;
  String? _decryptedText;
  late TextEncryption _textEncryption;
  EncryptionAlgorithm _selectedAlgorithm = EncryptionAlgorithm.AES;
  final Duration _sessionDuration = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _initializeEncryption();
  }

  void _initializeEncryption() {
    _textEncryption = TextEncryption(
      'my 32 length key................',
      sessionDuration: _sessionDuration,
      algorithm: _selectedAlgorithm,
    );
  }

  void _encryptText() {
    setState(() {
      _encryptedText = _textEncryption.encryptText(_encryptController.text);
    });
  }

  void _decryptText() {
    setState(() {
      _decryptedText = _textEncryption.decryptText(_decryptController.text);
      if (_decryptedText == null) {
        _decryptedText = "Session expired. Cannot decrypt.";
      }
    });
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
            color: Colors.grey[200],
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
                icon: Icon(Icons.copy, color: Colors.blueAccent),
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
        title: Text('Text Encryption'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<EncryptionAlgorithm>(
              value: _selectedAlgorithm,
              onChanged: (EncryptionAlgorithm? newValue) {
                setState(() {
                  _selectedAlgorithm = newValue!;
                  _initializeEncryption();
                });
              },
              items: EncryptionAlgorithm.values.map((EncryptionAlgorithm algorithm) {
                return DropdownMenuItem<EncryptionAlgorithm>(
                  value: algorithm,
                  child: Text(algorithm.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _encryptController,
              decoration: InputDecoration(
                labelText: 'Enter text to encrypt',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptText,
              child: Text('Encrypt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
            if (_encryptedText != null) ...[
              SizedBox(height: 20),
              _buildOutputBox(_encryptedText, 'Encrypted Text'),
            ],
            Divider(height: 40),
            TextField(
              controller: _decryptController,
              decoration: InputDecoration(
                labelText: 'Enter text to decrypt',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decryptText,
              child: Text('Decrypt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
            if (_decryptedText != null) ...[
              SizedBox(height: 20),
              _buildOutputBox(_decryptedText, 'Decrypted Text'),
            ],
            SizedBox(height: 20),
            Text(
              'Session expires at: ${_textEncryption.sessionEndTime}',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}