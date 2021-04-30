import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/userMenu/websiteListWidget.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import '../websites.dart';

class VaultPage extends StatefulWidget {
  final UsedWebsiteListNotifier websiteListNotifer;
  VaultPage(this.websiteListNotifer);
  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  @override
  Widget build(BuildContext context) {
    print("VaultPage Build: ${this.widget.websiteListNotifer}");
    return WebsiteList(widget.websiteListNotifer);
  }
}
