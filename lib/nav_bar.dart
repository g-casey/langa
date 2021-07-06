import 'package:flutter/material.dart';
import 'providers.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class TabNavBar extends StatelessWidget {
  late TextEditingController _filter;
  late FocusNode _focus;
  TabNavBar() {
    _filter = TextEditingController();
    _focus = FocusNode();
  }

  //TODO Seperate code for default app bar style
  void updateAppBar(BuildContext context, int index) {
    Provider.of<PageProvider>(context, listen: false).setIndex = index;
    if (Provider.of<PageProvider>(context, listen: false).getIndex == 1) {
      Provider.of<BarProvider>(context, listen: false).setAppBarTitle =
          FocusScope(
              child: Focus(
                  onFocusChange: (focus) =>
                      Provider.of<BarProvider>(context, listen: false)
                          .changeIcon(context, focus),
                  child: TextField(
                      controller: _filter,
                      decoration: new InputDecoration(
                          hintText: 'Search...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Provider.of<MangaProvider>(context, listen: false)
                                  .search(_filter.text);
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                          )))));
    } else {
      Provider.of<BarProvider>(context, listen: false).setAppBarTitle =
          BarProvider.buildAppBarTitle();
      Provider.of<BarProvider>(context, listen: false).setAppBarIconButton =
          BarProvider.buildAppBarIconButton();
    }

    _filter.addListener(() {
      print(_filter.text);
      //TODO Add search suggestions below search bar
      //Provider.of<SearchProvider>(context, listen: false).search(_filter.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        CustomNavigationBarItem(icon: Icon(Icons.search), title: Text("Search"))
      ],
      currentIndex: Provider.of<PageProvider>(context).getIndex,
      onTap: (index) => updateAppBar(context, index),
    );
  }
}
