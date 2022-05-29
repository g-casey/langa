import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga/manga.dart';
import 'package:manga/providers.dart';
import 'package:manga/reader_screen.dart';
import 'package:provider/provider.dart';

class RecentsScreen extends StatelessWidget {
  Future<List<MangaStorage>> _getStoredManga() async {
    Box box = await Hive.openBox("readingStorage");
    List<MangaStorage> recentlyRead = await box.get("recent");
    return List.from(recentlyRead.reversed);
  }

  void onTap(BuildContext context, MangaStorage mangaStorage) {
    Provider.of<MangaProvider>(context, listen: false).setCurrentPageIndex =
        mangaStorage.currentPage;
    Provider.of<MangaProvider>(context, listen: false).setCurrentChapterName = mangaStorage.manga.chapter;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ReaderScreen.loaded(mangaStorage.mangaImages)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MangaStorage>>(
        future: _getStoredManga(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
                padding: EdgeInsets.only(top: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 450,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          child: Column(
                            children: [
                              Image.network(snapshot.data?[index].manga.image,
                                  height: 185),
                              Text(snapshot.data?[index].manga.title,
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          onTap: () => onTap(context, snapshot.data![index]));
                    }));
          }
          return CircularProgressIndicator();
        }));
  }
}
