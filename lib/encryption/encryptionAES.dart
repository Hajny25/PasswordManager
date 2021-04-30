import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class AESEncryption {
  int blockSize;
  Key key;
  AESEncryption(String key64) {
    this.key = Key.fromBase64(key64);
    this.blockSize = 16;
  }

  String __pad(String plainText) {
    // return padded plain text whose length is a multiple of block size
    int numberOfBytesToPad =
        this.blockSize - (plainText.length % this.blockSize);
    String asciiString = new String.fromCharCode(
        numberOfBytesToPad); // similar to Python's char()
    String paddingString = asciiString * numberOfBytesToPad;
    String paddedPlainText = plainText + paddingString;
    return paddedPlainText;
  }

  String __unpad(String paddedText) {
    // inverse of __pad method
    String lastChar = paddedText[paddedText.length - 1];
    int numberOfbytesToRemove =
        lastChar.codeUnits.first; // similar to Python's ord()
    return paddedText.substring(0, paddedText.length - numberOfbytesToRemove);
  }

  String encrpyt(String plainText) {
    String paddedPlainText = this.__pad(plainText);
    final iv = IV.fromSecureRandom(this.blockSize);
    final encrypter =
        Encrypter(AES(this.key, mode: AESMode.cbc, padding: null));

    final encryptedText = encrypter.encrypt(paddedPlainText, iv: iv);
    return base64Encode(iv.bytes + encryptedText.bytes);
  }

  String decrypt(String enctyptedText) {
    final bytesList = base64Decode(enctyptedText);
    final iv = bytesList.sublist(0, this.blockSize);
    final encrypter =
        Encrypter(AES(this.key, mode: AESMode.cbc, padding: null));
    final plainText = encrypter
        .decrypt(Encrypted(bytesList.sublist(this.blockSize)), iv: IV(iv));
    return this.__unpad(plainText);
  }
}


/* void main() {
  final a = AESEncryption("lowTxJpSUDbS2Lj/fOfc1PRujhTZMn1SEpgmg5vm/R0=");
  final encrypted = a.encrpyt("Let's goo");
  print(encrypted);
  final decrypted = a.decrypt(encrypted);
  print(decrypted);
} */