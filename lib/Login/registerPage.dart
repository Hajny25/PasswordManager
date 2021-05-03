import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Login/loginPage.dart';
import '../Firebase/authExceptionHandler.dart';
import '../Firebase/authentication.dart';
import '../Firebase/database.dart';
import '../encryption/User.dart';
import '../userMenu/userMenu.dart'; // Text
import '../sql/databaseHandler.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formState = GlobalKey<FormState>();

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmationController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          top: false,
          child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(horizontal: 79),
              child: SingleChildScrollView(
                child: Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 150),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Register",
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        SizedBox(
                          height: 130,
                        ),
                        TextFormField(
                            controller: usernameController,
                            obscureText: false,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: _buildInputDecoration(
                                context, CupertinoIcons.person_alt, "Username"),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter a username.";
                              }
                              return null;
                            }),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: _buildInputDecoration(
                                context, CupertinoIcons.lock, "Password"),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter a password.";
                              }
                              if (val.length < 2) {
                                // TODO set to 6 after testing
                                return "Your password is too short. The length of your password should be at least 6 characters.";
                              }
                              return null;
                            }),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: confirmationController,
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: _buildInputDecoration(context,
                                CupertinoIcons.lock_fill, "Confirm password"),
                            validator: (val) {
                              if (passwordController.text.trim() !=
                                  confirmationController.text.trim()) {
                                return "Your passwords don't match.";
                              }
                              return null;
                            }),
                        SizedBox(height: 50),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 30),
                              primary: Theme.of(context).accentColor,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (_formState.currentState.validate()) {
                              signUpPrep();
                            } else {
                              print("Not successful.");
                            }
                          },
                          child: Text("Sign up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16)),
                        ),
                        SizedBox(height: 55),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(text: "Already have an account?\n"),
                                  TextSpan(
                                      text: "Sign in",
                                      style: Theme.of(context).textTheme.button,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => LoginPage());
                                        }),
                                ])),
                      ],
                    )),
              )),
        ));
  }

  void signUpPrep() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    print(username);
    print(password);
    UserEncryption userEncryption = UserEncryption(username, password);
    String email = createEmail(username);
    String passwordHash = userEncryption.getVerificationHash();
    // try to register
    final status =
        await FirebaseAuthHelper().createNewUser(email, passwordHash);
    if (status == AuthStatus.successful) {
      // move to User Menu
      await signUpSuccessful();
      Get.to(() => UserMenu());
    } else {
      // show Error Popup
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      print("Ready to show dialog.");
      Get.to(() => alertDialog(errorMsg));
    }
  }
}

Future<void> signUpSuccessful() async {
  User user = FirebaseAuthHelper().getCurrentUser();
  if (user == null) {
    user.reload();
  }
  await changeName(user);
  user = FirebaseAuthHelper().getCurrentUser();
  user.reload();
  await DatabaseHandler.setupDatabase();
}

InputDecoration _buildInputDecoration(
  BuildContext context,
  IconData icon,
  String labelText,
) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: Theme.of(context)
        .inputDecorationTheme
        .labelStyle
        .copyWith(fontSize: 15),
    hintStyle:
        Theme.of(context).inputDecorationTheme.hintStyle.copyWith(fontSize: 15),
    errorStyle:
        Theme.of(context).inputDecorationTheme.hintStyle.copyWith(fontSize: 15),
    suffixIcon: Icon(icon,
        color: Theme.of(context).inputDecorationTheme.labelStyle.color),
    border: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context)
                .inputDecorationTheme
                .labelStyle
                .color)), //MyColors.grey[7])), // 7
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context)
                .inputDecorationTheme
                .hintStyle
                .color)), //MyColors.grey[5])), // 5
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context)
                .inputDecorationTheme
                .labelStyle
                .color)), //MyColors.grey[7])), // 7
    errorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  );
}

// class LoadingScreenRegister extends StatefulWidget {
//   LoadingScreenRegister({Key key}) : super(key: key);

//   @override
//   _LoadingScreenRegisterState createState() => _LoadingScreenRegisterState();
// }

// class _LoadingScreenRegisterState extends State<LoadingScreenRegister> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: signUpSuccessful(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             Get.to(() => UserMenu());
//           } else {
//             showCupertinoDialog(
//                 context: context,
//                 builder: (context) => CupertinoAlertDialog(
//                     title: Text("Logging in..."),
//                     content: CupertinoActivityIndicator(radius: 20.0)));
//           }
//         });
//   }
// }
