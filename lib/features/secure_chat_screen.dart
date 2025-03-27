import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureChatScreen extends StatefulWidget {
  @override
  _SecureChatScreenState createState() => _SecureChatScreenState();
}

class _SecureChatScreenState extends State<SecureChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  List<String> _encryptedMessages = [];

  final _key = encrypt.Key.fromUtf8('my 32 length key................');
  final _iv = encrypt.IV.fromLength(16);
  late final encrypt.Encrypter _encrypter;

  @override
  void initState() {
    super.initState();
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  void _sendMessage() {
    final encrypted = _encrypter.encrypt(_controller.text, iv: _iv);
    setState(() {
      _encryptedMessages.add(encrypted.base64);
      _messages.add(_controller.text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}