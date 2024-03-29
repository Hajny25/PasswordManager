import 'package:flutter/material.dart';
import "package:get/get.dart";

enum AuthStatus {
  successful,
  emailAlreadyInUse,
  weakPassword,
  userNotFound,
  wrongPassword,
  operationNotAllowed,
  tooManyRequests,
  userDisabled,
  undefined,
}

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyInUse;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "operation-not-allowed":
        status = AuthStatus.operationNotAllowed;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;
      default:
        status = AuthStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthStatus.emailAlreadyInUse:
        errorMessage =
            "This username is already used. Please provide another one.";
        break;

      case AuthStatus.weakPassword:
        errorMessage =
            "The password provided is too weak. Please provide another one.";
        break;

      case AuthStatus.userNotFound:
        errorMessage = "There is no user with this name.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Wrong username/password combination.";
        break;
      case AuthStatus.operationNotAllowed:
        errorMessage = "This operation is not allowed. Please try again later.";
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthStatus.userDisabled:
        errorMessage = "User with this username has been disabled.";
        break;
      default:
        errorMessage = "An undefined error happened. Try again later.";
    }
    return errorMessage;
  }
}

Widget alertDialog(BuildContext context, String msg) {
  return AlertDialog(
    title: Text("Authentication Error"),
    backgroundColor: Theme.of(context).cardColor,
    content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
    actions: <Widget>[
      Align(
        alignment: Alignment.center,
        child: OutlinedButton(
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              Get.back();
            },
            style:  OutlinedButton.styleFrom(
                                primary: Theme.of(context).accentColor,   
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
      ))
    ],
  );
}
