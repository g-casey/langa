import 'package:flutter/material.dart';
import 'package:manga/app_bar.dart';
import 'package:manga/main_screen.dart';
import 'package:manga/search_screen.dart';
import 'package:provider/provider.dart';
import 'nav_bar.dart';
import 'providers.dart';

void main() {
  runApp(new HomePageWidget());
}

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: BarProvider(),
        ),
        ChangeNotifierProvider.value(value: PageProvider()),
        ChangeNotifierProvider.value(value: MangaProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: TopBar(),
          body: Consumer<PageProvider>(
            builder: (_, pageprovider, __) => IndexedStack(
              index: pageprovider.getIndex,
              children: [MainScreen(), SearchScreen()],
            ),
          ),
          bottomNavigationBar: TabNavBar(),
        ),
      ),
    );
  }
}
