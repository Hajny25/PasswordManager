import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:password_manager/Firebase/database.dart' as database;
import 'package:password_manager/themes/colors.dart';
import 'package:password_manager/userMenu/websiteNotifier.dart';
import 'package:provider/provider.dart';

import '../websites.dart';
import 'websiteCloseUp.dart';

class WebsiteList extends StatefulWidget {
  final List<UserWebsite> websiteList;
  final String page; // to identify whether vault or favorite page
  WebsiteList(this.websiteList, this.page);

  @override
  _WebsiteListState createState() => _WebsiteListState();
}

class _WebsiteListState extends State<WebsiteList> {
  List<UserWebsite> websitesToDisplay;

  @override
  void initState() {
    print("WebsiteList: ${this.widget.websiteList}");
    this.websitesToDisplay = this.widget.websiteList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: false,
      child: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
            backgroundColor: MyColors.backgroundDark,
            pinned: false,
            floating: true,
            snap: false,
            title: Container(color: Colors.orange),
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(horizontal: 20),
                centerTitle: true,
                title: Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoSearchTextField(onChanged: (text) {
                      setState(() {
                        this.websitesToDisplay = this
                            .widget
                            .websiteList
                            .where((element) => element.websiteName
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                      });
                    })))),
        if (this.widget.websiteList.isEmpty)
          _websiteEmpty()
        else if (websitesToDisplay.isEmpty)
          _noSearchResults()
        else
          _websiteBody()
      ]),
    );
  }

  Widget _websiteBody() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var website = websitesToDisplay[index];
      bool isFavorite = website.isFavorite;
      return Slidable(
        key: Key(index.toString()),
        actionPane: SlidableScrollActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: "Favorite",
            color: Theme.of(context).scaffoldBackgroundColor,
            icon: isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            foregroundColor: Colors.red,
            onTap: () {
              setState(() {
                website.toggleFavorite();
                database.updateIsFavorite(website); //DatabaseHander.updateFavorite(website)
                if (this.widget.page != "vault") {
                  this.websitesToDisplay.remove(website);
                }
              });
              print(website.isFavorite);
            },
          )
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.5),
            GestureDetector(
              onTap: () {
                Get.to(() => WebsiteClose(website));
              },
              child: Card(
                color: MyColors.cardDark,
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                color: MyColors.pictureBackgroundDark,
                                height: 75,
                                width: 75,
                                padding: EdgeInsets.all(12.5),
                                child: Hero(
                                    tag: website.websiteName,
                                    child: website.getImage()))),
                      ),
                      Text(website.websiteName,
                          style: Theme.of(context).textTheme.subtitle2)
                    ]),
              ),
            ),
          ],
        ),
      );
    }, childCount: websitesToDisplay.length));
  }

  Widget _websiteEmpty() {
    String emptyText = this.widget.page == "vault"
        ? "This looks empty.\n Start by adding a new website!"
        : "You haven't added any favorites yet.";
    return SliverFillRemaining(
        child: Center(
            child: Text(emptyText,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w400))));
  }

  Widget _noSearchResults() {
    return SliverFillRemaining(
        child: Center(
            child: Text("No results found.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w400))));
  }
}
