import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _storage = const FlutterSecureStorage();

  Future<void> setupKeys(String userId) async {
    final existing = await _storage.read(key: 'privateKey_$userId');
    if (existing != null) return;

    final keyPair = _generateKeyPair();
    final privateKey = _encodePrivateKey(keyPair.privateKey as RSAPrivateKey);
    final publicKey = _encodePublicKey(keyPair.publicKey as RSAPublicKey);

    await _storage.write(key: 'privateKey_$userId', value: privateKey);

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'publicKey': publicKey,
    });
  }

  Future<String> encryptMessage(
    String message,
    String receiverPublicKeyStr,
  ) async {
    try {
      final publicKey = _decodePublicKey(receiverPublicKeyStr);
      final encryptor = OAEPEncoding(RSAEngine())
        ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
      final encrypted = encryptor.process(
        Uint8List.fromList(utf8.encode(message)),
      );
      return base64.encode(encrypted);
    } catch (e) {
      return message;
    }
  }

  Future<String> decryptMessage(String encryptedMsg, String userId) async {
    try {
      final privateKeyStr = await _storage.read(key: 'privateKey_$userId');
      if (privateKeyStr == null) return '[Decryption failed]';

      final privateKey = _decodePrivateKey(privateKeyStr);
      final decryptor = OAEPEncoding(RSAEngine())
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
      final decrypted = decryptor.process(base64.decode(encryptedMsg));
      return utf8.decode(decrypted);
    } catch (e) {
      return '[Decryption failed]';
    }
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> _generateKeyPair() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
        KeyParameter(Uint8List.fromList(List.generate(32, (i) => i * 7 + 3))),
      );
    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
          secureRandom,
        ),
      );
    return keyGen.generateKeyPair();
  }

  String _encodePublicKey(RSAPublicKey key) =>
      base64.encode(utf8.encode('${key.modulus}|${key.exponent}'));

  String _encodePrivateKey(RSAPrivateKey key) => base64.encode(
    utf8.encode('${key.modulus}|${key.privateExponent}|${key.p}|${key.q}'),
  );

  RSAPublicKey _decodePublicKey(String encoded) {
    final parts = utf8.decode(base64.decode(encoded)).split('|');
    return RSAPublicKey(BigInt.parse(parts[0]), BigInt.parse(parts[1]));
  }

  RSAPrivateKey _decodePrivateKey(String encoded) {
    final parts = utf8.decode(base64.decode(encoded)).split('|');
    return RSAPrivateKey(
      BigInt.parse(parts[0]),
      BigInt.parse(parts[1]),
      BigInt.parse(parts[2]),
      BigInt.parse(parts[3]),
    );
  }
}
