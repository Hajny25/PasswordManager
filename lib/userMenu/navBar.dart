import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final Function callback;
  final int _currentIndex;
  NavigationBar(this._currentIndex, this.callback);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index) => callback(index),
        backgroundColor: Theme.of(context).backgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.lock_shield, size: 28),
              activeIcon: Icon(CupertinoIcons.lock_shield_fill, size: 28),
              label: "Vault"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart, size: 28),
              activeIcon: Icon(CupertinoIcons.heart_fill, size: 28),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key_outlined, size: 28),
              activeIcon: Icon(Icons.vpn_key, size: 28),
              label: "Generator")
        ]);
  }
}