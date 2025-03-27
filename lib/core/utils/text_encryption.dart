import 'package:encrypt/encrypt.dart' as encrypt;

enum EncryptionAlgorithm { AES, Fernet, Salsa20 }

class TextEncryption {
  final encrypt.Key key;
  final encrypt.IV iv;
  late final encrypt.Encrypter encrypter;
  late DateTime sessionEndTime;
  final EncryptionAlgorithm algorithm;

  TextEncryption(String keyString, {required Duration sessionDuration, required this.algorithm})
      : key = encrypt.Key.fromUtf8(keyString.padRight(32, ' ')),
        iv = encrypt.IV.fromLength(8) {
    switch (algorithm) {
      case EncryptionAlgorithm.AES:
        encrypter = encrypt.Encrypter(encrypt.AES(key));
        break;
      case EncryptionAlgorithm.Fernet:
        final fernetKey = encrypt.Key.fromUtf8(keyString.padRight(32, ' '));
        encrypter = encrypt.Encrypter(encrypt.Fernet(fernetKey));
        break;
      case EncryptionAlgorithm.Salsa20:
        encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
        break;
    }
    sessionEndTime = DateTime.now().add(sessionDuration);
  }

  String encryptText(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String? decryptText(String encryptedText) {
    if (DateTime.now().isAfter(sessionEndTime)) {
      return null;
    }
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}