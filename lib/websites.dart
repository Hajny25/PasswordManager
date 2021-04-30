import 'package:flutter/material.dart';
import 'dart:io';
import 'globals.dart' as Globals;

class Website {
  String websiteName;
  int update; // 0: from beginning, n: added with update no. n

  Website(this.websiteName, this.update);

  // factory Website.fromMap(Map<String, dynamic> map) {
  //   return Website(map["websiteName"], map["update"]);
  // }

  Widget getImage({double width, double height}) {
    if (this.update == 0) {
      return Image.asset(
        "assets/images/logos/logo_${websiteName.toLowerCase()}.png",
        width: width,
        height: height,
      );
    } else {
      return Image.file(
          File(
              "${Globals.appDir}/Update${this.update}/logo_${websiteName.toLowerCase()}.png"),
          width: width,
          height: height);
    }
  }
}

class UserWebsite extends Website {
  String username;
  String password;
  bool isFavorite;

  UserWebsite(websiteName, update, this.username, this.password,
      [this.isFavorite = false])
      : super(websiteName, update);

  void toggleFavorite() {
    this.isFavorite = !this.isFavorite;
  }
}
