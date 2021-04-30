import 'package:firebase_auth/firebase_auth.dart';
import 'authExceptionHandler.dart';

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;
  AuthStatus _status;
/*   FirebaseAuthHelper.listener();

  void listener() {
    _auth.userChanges().listen((User user) {
      if (user == null) {
        print("User is currently signed out.");
      } else {
        print("User is currently signed in.");
      }
    });
  } */

  Future<AuthStatus> createNewUser(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        this._status = AuthStatus.successful;
        print(userCredential.user == this.getCurrentUser());
      } else {
        this._status = AuthStatus.undefined;
      }
    } catch (e) {
      print("Exception @create_account: $e");
      this._status = AuthExceptionHandler.handleException(e);
    }
    return this._status;
  }

  Future<AuthStatus> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        this._status = AuthStatus.successful;
        print(userCredential.user == this._auth.currentUser);

      } else {
       this._status = AuthStatus.undefined;
      }
    } catch (e) {
      print("Exception @login: $e");
      _status = AuthExceptionHandler.handleException(e);
    }
    return this._status;
  }

  User getCurrentUser() {
    User user = _auth.currentUser;
    if (user == null) {
      user.reload();
    }
    return _auth.currentUser;
  }

  logout() {
    _auth.signOut();
  }
}
