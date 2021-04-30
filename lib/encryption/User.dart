import 'background_pbkdf2/pbkdf2.dart';

class UserEncryption {
  String username;
  String password;
  String vaultKey;
  String verificationHash;
  final hash = new PBKDF2();
  final roundsVaultKey = 100000;
  final roundsVerificationHash = 5000;
  final keyLength = 32;

  UserEncryption(username, password) {
    this.username = username;
    this.password = password;
  }

  void computeVaultKey() {
    this.vaultKey = this.hash.generateBase64Key(
        this.username, this.password, this.roundsVaultKey, this.keyLength);
  }

  void computeVerificationHash() {
    if (vaultKey == null) {
      this.computeVaultKey();
    }
    this.verificationHash = this.hash.generateBase64Key(this.vaultKey,
        this.password, this.roundsVerificationHash, this.keyLength);
  }

  String getVaultKey() {
    if (vaultKey == null) {
      this.computeVaultKey();
    }
    return this.vaultKey;
  }

  String getVerificationHash() {
    if (verificationHash == null) {
      this.computeVerificationHash();
    }
    return this.verificationHash;
  }
}


String createEmail(String username) {
  return username + "@dummy123.hu";
}

/* void main() {
  final u = UserEncryption("test", "123");
  print(u.getVaultKey());
} */
