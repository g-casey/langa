import 'package:flutter/material.dart';
import 'package:manga/manga.dart';

import 'get_manga.dart';

class BarProvider extends ChangeNotifier {
  static Widget buildAppBarTitle() {
    return Text(
      'Manga',
      style: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black,
        fontSize: 26,
      ),
    );
  }

  static IconButton buildAppBarIconButton() {
    return IconButton(
      icon: Icon(Icons.menu),
      //TODO implement drawer here
      onPressed: () {},
    );
  }

  late Widget _appBarTitle;
  late IconButton _appBarIconButton;

  BarProvider() {
    _appBarTitle = buildAppBarTitle();
    _appBarIconButton = buildAppBarIconButton();
  }

  void changeIcon(BuildContext context, bool focus) {
    if (focus) {
      _appBarIconButton = IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
      );
    } else {
      _appBarIconButton = buildAppBarIconButton();
    }
    notifyListeners();
  }

  get getAppBarIconButton => _appBarIconButton;
  get getAppBarTitle => _appBarTitle;

  set setAppBarTitle(Widget widget) {
    _appBarTitle = widget;
    notifyListeners();
  }

  set setAppBarIconButton(IconButton icon) {
    _appBarIconButton = icon;
    notifyListeners();
  }
}

class PageProvider extends ChangeNotifier {
  int _currentIndex = 0;

  get getIndex => _currentIndex;
  set setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class SearchProvider extends ChangeNotifier {
  List<Manga> _results = [];

  get getResults => _results;

  void search(String text) async {
    Downloader loader = Downloader("es", text);
    _results = await loader.search();
    print(text);

    print(_results[0].title);
    notifyListeners();
  }
}
