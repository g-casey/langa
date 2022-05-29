import 'package:flutter/material.dart';
import 'package:manga/app_bar.dart';
import 'package:manga/main_screen.dart';
import 'package:manga/manga.dart';
import 'package:manga/search_screen.dart';
import 'package:provider/provider.dart';
import 'recents_screen.dart';
import 'nav_bar.dart';
import 'providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MangaAdapter());
  Hive.registerAdapter(ChapterAdapter());
  Hive.registerAdapter(MangaStorageAdapter());
  Box box = await Hive.openBox("readingStorage");
  if (!box.containsKey("recents")) {
    List<MangaStorage> recents = [];
    box.put("recent", recents);
  }
  runApp(new HomePageWidget());
}

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BarProvider()),
        ChangeNotifierProvider.value(value: PageProvider()),
        ChangeNotifierProvider.value(value: MangaProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder( 
          builder: (BuildContext newContext){
          return Scaffold(
          appBar: 
              Provider.of<BarProvider>(newContext).showMainAppBar ? TopBar() : null,
          body: Consumer<PageProvider>(
            builder: (_, pageprovider, __) => IndexedStack(
              index: pageprovider.getIndex,
              children: [MainScreen(), SearchScreen(), RecentsScreen()],
            ),
          ),
          bottomNavigationBar: TabNavBar(),
        );
  })),
    );
  }
}
