import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteListWidget.dart';
import '../websites.dart';

class VaultPage extends StatefulWidget {
  final List<UserWebsite> websiteList;
  VaultPage(this.websiteList);
  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  @override
  Widget build(BuildContext context) {
    print("VaultPage Build: ${this.widget.websiteList}");
    return WebsiteList(widget.websiteList);
  }
}
