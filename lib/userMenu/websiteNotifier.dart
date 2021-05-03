import 'package:flutter/material.dart';

import '../websites.dart';

class WebsiteListNotifier<T extends Website> extends ValueNotifier<List<T>> {
  List<T> list;
  WebsiteListNotifier(this.list) : super(list);

  void addWebsite(T website) {
    this.value.add(website);
    notifyListeners();
  }

  void removeWebsite(T website) {
    this.value.remove(website);
    notifyListeners();
  }
}
