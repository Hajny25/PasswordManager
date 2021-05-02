import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/Firebase/authentication.dart';
import 'package:password_manager/Firebase/database.dart';
import 'package:password_manager/userMenu/passwordGenerator.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:password_manager/websites.dart';
import 'package:password_manager/cupertinoHelpers.dart';
import 'package:provider/provider.dart';

class AddWebsitePopUp extends StatefulWidget {
  AddWebsitePopUp();
  @override
  _AddWebsitePopUpState createState() => _AddWebsitePopUpState();
}

class _AddWebsitePopUpState extends State<AddWebsitePopUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final scrollController = FixedExtentScrollController();
  UnusedWebsite website;
  List<UnusedWebsite> websitesToDisplay;

  @override
  void initState() {
    this.websitesToDisplay = Provider.of<UnusedWebsiteListNotifier>(context, listen: false).value;
    super.initState();
  }

  void deleteUnusedWebsite(UnusedWebsite website) {
    this.websitesToDisplay.remove(website);
  }

  @override
  Widget build(BuildContext context) {
    List<UnusedWebsite> websitesList =
        Provider.of<UnusedWebsiteListNotifier>(context).value;
    //this.websitesToDisplay = websitesList;
    return SafeArea(
        child: CupertinoAlertDialog(
      title: Text("Add website"),
      content: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: CupertinoSearchTextField(
              onChanged: (text) {
                setState(() {
                  websitesToDisplay = websitesList
                      .where((element) => element.websiteName
                          .toLowerCase()
                          .contains(text.toLowerCase()))
                      .toList();
                });
              },
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: CupertinoPicker.builder(
              scrollController: scrollController,
              diameterRatio: 2,
              backgroundColor: Colors.black,
              childCount: this.websitesToDisplay.length,
              itemExtent: 40,
              onSelectedItemChanged: (index) {}, // intended, no change needed
              itemBuilder: (context, index) {
                var website = this.websitesToDisplay[index];
                return Center(
                    child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 8),
                      child: website.getImage(width: 30, height: 30),
                    ),
                    Text(
                      website.websiteName,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ));
              },
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Your username:",
                    style: Theme.of(context).textTheme.bodyText1))),
        cupertinoTextField(context, usernameController,
            CupertinoIcons.person_alt_circle_fill, "Username"),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Your password:",
                    style: Theme.of(context).textTheme.bodyText1))),
        cupertinoTextField(context, passwordController,
            CupertinoIcons.lock_circle_fill, "Password"),
        CupertinoButton(
          child: Text("Generate Password"),
          onPressed: () {
            String password = getPassword(20);
            setState(() {
              passwordController.text = password;
            });
          },
        )
      ]),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancel", style: Theme.of(context).textTheme.bodyText1),
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
            child:
                Text("Confirm", style: Theme.of(context).textTheme.bodyText1),
            isDefaultAction: true,
            onPressed: onConfirm),
      ],
    ));
  }

  void onConfirm() {
    if (this.websitesToDisplay.isNotEmpty) {
      User user = FirebaseAuthHelper().getCurrentUser();
      UnusedWebsite website =
          this.websitesToDisplay[this.scrollController.selectedItem];
      String username = usernameController.text;
      String password = passwordController.text;
      print(website.websiteName);
      print(username);
      print(password);

      addWebsitePassword(user, website, username, password);
      deleteUnusedWebsite(website);
      print(this.websitesToDisplay);
      //this.widget.updateWebsites(website);
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text("No website provided."),
                content: Text("Please select a website."),
                actions: [
                  CupertinoDialogAction(
                    child: Text("Cancel"),
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
  }
}
