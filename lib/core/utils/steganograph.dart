import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class Steganograph {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<bool> encode({
    required String inputFilePath,
    required String outputFilePath,
    required String message,
  }) async {
    File inputFile = File(inputFilePath);
    File resizedImage = await FlutterNativeImage.compressImage(inputFile.path, quality: 80, percentage: 100);

    final encodedImage = _encodeTextInImage(resizedImage, message);
    encodedImage.writeAsBytesSync(encodedImage.readAsBytesSync());
    return true;
  }

  Future<String?> decode({
    required String inputFilePath,
  }) async {
    File inputFile = File(inputFilePath);
    return _decodeTextFromImage(inputFile);
  }

  File _encodeTextInImage(File imageFile, String text) {
    final bytes = utf8.encode(text);
    final imageBytes = imageFile.readAsBytesSync();
    final encodedBytes = Uint8List.fromList(imageBytes + bytes);
    return File(imageFile.path)..writeAsBytesSync(encodedBytes);
  }

  String? _decodeTextFromImage(File imageFile) {
    final imageBytes = imageFile.readAsBytesSync();
    // Assuming the message length is known or fixed, here we use 13 bytes for 'Hello, World!'
    final messageLength = 13;
    final messageBytes = imageBytes.sublist(imageBytes.length - messageLength);
    return utf8.decode(messageBytes);
  }
}