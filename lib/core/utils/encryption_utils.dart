import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart' as rsa;
import 'package:pointycastle/key_generators/api.dart' as rsa;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/random/fortuna_random.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

class EncryptionUtils {
  static final _key = encrypt.Key.fromUtf8('my 32 length key................');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static encrypt.Encrypted encryptText(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv);
  }

  static String decryptText(encrypt.Encrypted encryptedText) {
    return _encrypter.decrypt(encryptedText, iv: _iv);
  }

  static crypto.AsymmetricKeyPair<rsa.RSAPublicKey, rsa.RSAPrivateKey> generateRSAKeyPair({int bitLength = 2048}) {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(255));
    secureRandom.seed(crypto.KeyParameter(Uint8List.fromList(seeds)));

    var keyGen = RSAKeyGenerator()
      ..init(crypto.ParametersWithRandom(
          rsa.RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));
    final pair = keyGen.generateKeyPair();
    final privateKey = pair.privateKey as rsa.RSAPrivateKey;
    final publicKey = pair.publicKey as rsa.RSAPublicKey;
    return crypto.AsymmetricKeyPair<rsa.RSAPublicKey, rsa.RSAPrivateKey>(publicKey, privateKey);
  }

  static encrypt.Encrypted rsaEncrypt(String data, rsa.RSAPublicKey publicKey) {
    final encryptor = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    return encryptor.encrypt(data);
  }

  static String rsaDecrypt(encrypt.Encrypted data, rsa.RSAPrivateKey privateKey) {
    final decryptor = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
    return decryptor.decrypt(data);
  }

  static List<int> encryptFile(File file) {
    final fileBytes = file.readAsBytesSync();
    final encryptedBytes = _encrypter.encryptBytes(fileBytes, iv: _iv);
    return encryptedBytes.bytes;
  }
}