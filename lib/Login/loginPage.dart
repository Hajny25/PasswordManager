import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Login/registerPage.dart';
import '../Firebase/authExceptionHandler.dart';
import '../Firebase/authentication.dart';
import '../encryption/User.dart';
import '../userMenu/userMenu.dart'; // Text

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formState = GlobalKey<FormState>();

  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

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
                            child: Text("Login",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline1)),
                        SizedBox(
                          height: 130,
                        ),
                        TextFormField(
                            controller: usernameController,
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
                              return null;
                            }),
                        SizedBox(height: 50),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                primary: Theme.of(context).accentColor,
                                minimumSize: Size(double.maxFinite, 30),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 95, vertical: 15),
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (_formState.currentState.validate()) {
                                signInPrep();
                              } else {
                                print("Not successful.");
                              }
                            },
                            child: Text("Login",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.button)),
                        SizedBox(height: 20),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(text: "Don't have an account?\n"),
                                  TextSpan(
                                      text: "Register",
                                      style: Theme.of(context).textTheme.button,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => RegisterPage());
                                        }),
                                  TextSpan(text: " now!")
                                ])),
                      ],
                    )),
              )),
        ));
  }

  void signInPrep() async {
    String username = usernameController.text;
    String password = passwordController.text;
    print(username);
    print(password);
    UserEncryption userEncryption = UserEncryption(username, password);

    String email = createEmail(username);
    String passwordHash = userEncryption.getVerificationHash();
    final status = await FirebaseAuthHelper().signIn(email, passwordHash);
    if (status == AuthStatus.successful) {
      User user = FirebaseAuthHelper().getCurrentUser();
      print(user);
      if (user != null) {
        await user.reload();
      }
      Get.to(() => UserMenu());
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
      Get.to(() => alertDialog(errorMsg));
    }
  }
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
