import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/themes/colors.dart';
import 'package:flutter/services.dart'; // Clipboard
import '../themes/darkTheme.dart'; // ColorScheme extension
import '../cupertinoHelpers.dart';
import '../websites.dart';

class WebsiteClose extends StatefulWidget {
  final UserWebsite website;
  WebsiteClose(this.website);

  @override
  _WebsiteCloseState createState() => _WebsiteCloseState();
}

class _WebsiteCloseState extends State<WebsiteClose> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MyColors.barDark,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            color: MyColors.ctaDark,
            tooltip: "Back",
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            widget.website.websiteName,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            IconButton(
                icon: Icon(CupertinoIcons.wrench),
                color: MyColors.ctaDark,
                tooltip: "Change Username or Password",
                onPressed: () {
                  _showSettings(context);
                }),
          ]),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: MyColors.cardDark),
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              child: Column(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: MyColors.pictureBackgroundDark),
                    child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Hero(
                            tag: this.widget.website.websiteName,
                            child: this
                                .widget
                                .website
                                .getImage(width: 200, height: 200)))),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.widget.website.websiteName,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                )
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: _textField(this.widget.website.username, false),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: _textField(this.widget.website.password, this._hidden)),
          TextButton(
              onPressed: () {
                setState(() {
                  this._hidden = !this._hidden;
                });
              },
              child: Text(_hidden ? "Show Password" : "Hide Password",
                  style: TextStyle(
                      color: MyColors.ctaDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline)))
        ]),
      ),
    );
  }

  _textField(String initialValue, hidden) {
    return Row(children: <Widget>[
      Expanded(
          child: TextFormField(
        initialValue: initialValue,
        readOnly: true,
        obscureText: hidden,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.grey[17],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red))),
      )),
      SizedBox(width: 25),
      Container(
          decoration: BoxDecoration(
              color: MyColors.ctaDark, borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(vertical: 2),
          child: IconButton(
              icon: Icon(Icons.copy),
              color: MyColors.backgroundDark,
              onPressed: () {
                Clipboard.setData(
                    new ClipboardData(text: this.widget.website.password));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Copied."),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                ));
              }))
    ]);
  }

  _showSettings(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text("Settings"),
            message: Text("You can change your username or password."),
            actions: [
              CupertinoActionSheetAction(
                child: Text("Change username",
                    style: Theme.of(context).textTheme.button),
                onPressed: () => _showChangeDialog(context, "username"),
              ),
              CupertinoActionSheetAction(
                child: Text("Change password",
                    style: Theme.of(context).textTheme.button),
                onPressed: () => _showChangeDialog(context, "password"),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel",
                  style: Theme.of(context).textTheme.button.copyWith(
                      fontWeight: FontWeight.w100,
                      color: Theme.of(context).errorColor)),
              //isDestructiveAction: true,
              onPressed: () {
                Get.back();
              },
            ),
          );
        });
  }

  _showChangeDialog(BuildContext context, String valueToChange) {
    IconData suffixIcon1;
    IconData suffixIcon2;
    if (valueToChange == "username") {
      suffixIcon1 = CupertinoIcons.person_alt_circle;
      suffixIcon2 = CupertinoIcons.person_alt_circle_fill;
    } else {
      suffixIcon1 = CupertinoIcons.lock_circle;
      suffixIcon2 = CupertinoIcons.lock_circle_fill;
    }
    showCupertinoDialog(
        context: context,
        builder: (context) =>
            ChangeDialog(valueToChange, suffixIcon1, suffixIcon2));
  }
}

// ignore: must_be_immutable
class ChangeDialog extends StatelessWidget {
  final String valueToChange;
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final IconData suffixIcon1;
  final IconData suffixIcon2;
  String placeholder1;
  String placeholder2;

  ChangeDialog(this.valueToChange, this.suffixIcon1, this.suffixIcon2) {
    this.placeholder1 = "New $valueToChange";
    this.placeholder2 = "Confirm $valueToChange";
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Change $valueToChange"),
      content: SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text("New $valueToChange",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          cupertinoTextField(context, controller1, suffixIcon1, placeholder1),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Text("Confirm new $valueToChange",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
          cupertinoTextField(context, controller2, suffixIcon2, placeholder2)
        ]),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancel",
              style: Theme.of(context).textTheme.button.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).errorColor)),
          isDestructiveAction: true,
          onPressed: () => Get.back(),
        ),
        CupertinoDialogAction(
            child: Text("Confirm",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(fontWeight: FontWeight.normal)),
            isDefaultAction: true,
            onPressed: () => showConfirmDialog(context, valueToChange)),
      ],
    );
  }

  void showConfirmDialog(BuildContext context, String valueToChange) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title:
                  Text("Are you sure you want to change your $valueToChange"),
              content: Text(
                  "This action does not change your actual $valueToChange on your real account. The changes only affect the PasswordManager."),
              actions: [
                CupertinoDialogAction(
                  child: Text("Cancel",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontWeight: FontWeight.normal)),
                  isDestructiveAction: true,
                  onPressed: () => Get.back(),
                ),
                CupertinoDialogAction(
                    child: Text("Change $valueToChange",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontWeight: FontWeight.normal)),
                    isDefaultAction: true,
                    onPressed: () {
                      //changePassword()
                    }),
              ],
            ));
  }
}
