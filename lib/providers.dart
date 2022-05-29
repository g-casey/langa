import 'package:flutter/material.dart';
import 'package:manga/manga.dart';

import 'get_manga.dart';

class BarProvider extends ChangeNotifier {
  static Widget buildAppBarTitle() {
    return Text(
      "Manga", 
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

  late bool _showAppBar;
  late bool _showMainAppBar;
  late Widget _appBarTitle;
  late Widget _appBarIconButton;

  BarProvider() {
    _appBarTitle = buildAppBarTitle();
    _appBarIconButton = SizedBox.shrink();
    _showAppBar = true;
    _showMainAppBar = false;
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
      _appBarIconButton = SizedBox.shrink();
    }
    notifyListeners();
  }

  get getAppBarIconButton => _appBarIconButton;
  get getAppBarTitle => _appBarTitle;
  get showAppBar => _showAppBar;
  get showMainAppBar => _showMainAppBar;

  set setAppBarTitle(Widget widget) {
    _appBarTitle = widget;
    notifyListeners();
  }

  set setAppBarIconButton(IconButton icon) {
    _appBarIconButton = icon;
    notifyListeners();
  }

  void toggleShowAppBar() {
    _showAppBar = !_showAppBar;
    notifyListeners();
  }

  void enableMainAppBar(){
    _showMainAppBar = true;
    notifyListeners();
  }

  void disableMainAppBar(){
    _showMainAppBar = false;
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

class MangaProvider extends ChangeNotifier {
  List<Manga> _results = [];
  int _currentPageIndex = 0;
  String? _currentChapterName;
  int? _currentChapterIndex;

  get getResults => _results;
  get getCurrentPageIndex => _currentPageIndex;
  get getCurrentChapterName => _currentChapterName;

  set setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  set setCurrentChapterName(String name) {
    _currentChapterName = name;
    notifyListeners();
  }

  void search(String text) async {
    Downloader loader = Downloader("es", text);
    _results = await loader.search();

    notifyListeners();
  }
}
