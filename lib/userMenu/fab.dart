import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';

import '../websites.dart';
import 'addWebsite.dart';

Widget floatingActionButton(BuildContext context, UnusedWebsiteListNotifier unusedWebsiteListNotifier) {
  return SizedBox(
      width: 120,
      child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Text(
                    "ADD",
                    style: TextStyle(fontSize: 18),
                  )
                ]),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AddWebsitePopUp(unusedWebsiteListNotifier));
          })
      );
}