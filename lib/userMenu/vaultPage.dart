import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteListWidget.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:provider/provider.dart';
import '../websites.dart';

class VaultPage extends StatefulWidget {
  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  @override
  Widget build(BuildContext context) {
    //print("VaultPage Build: ${this.widget.websiteListNotifer}");
    List<UserWebsite> websiteList =
        Provider.of<UsedWebsiteListNotifier>(context).value;
    print("Vault Build: $websiteList");
    return WebsiteList(websiteList);
  }
}
