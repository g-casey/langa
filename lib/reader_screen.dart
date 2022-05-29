import 'dart:html';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:manga/providers.dart';
import 'package:provider/provider.dart';
import 'get_manga.dart';
import 'package:hive/hive.dart';
import 'manga.dart';

class ReaderScreen extends StatelessWidget {
  String? _imageListUrl;
  Manga? _currentManga;
  List<String>? _imageLinks;

  ReaderScreen(this._imageListUrl, this._currentManga);
  ReaderScreen.loaded( this._imageLinks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Provider.of<BarProvider>(context).showAppBar
            ? AppBar(
                elevation: 0,
                title: Text(
                  Provider.of<MangaProvider>(context, listen: false)
                          .getCurrentChapterName ??
                      "",
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 14.0),
                ),
                backgroundColor: Colors.grey.shade800,
                iconTheme: IconThemeData(color: Colors.grey.shade100))
            : null,
        body: _imageLinks == null ? ReadingView(_imageListUrl!, _currentManga!) : Reader(_imageLinks!));
  }
}

class ReadingView extends StatelessWidget{


  String _imageListUrl; 
  Manga _currentManga; 

  ReadingView(this._imageListUrl, this._currentManga);
  
Future<List<String>> fetchImageLinks(BuildContext context) async {
    List<String> imageLinks = await Downloader.getMangaImages(_imageListUrl);
    return imageLinks;
  }

  void setRecentsPage(BuildContext context, List<String> imageLinks) async{
    int currentPage = Provider.of<MangaProvider>(context, listen: false).getCurrentPageIndex;
    Box box = await Hive.openBox("readingStorage");
    List<MangaStorage> recents = box.get("recent");
    MangaStorage mostRecent = MangaStorage(_currentManga,imageLinks, currentPage); 

    for(MangaStorage ms in recents){
      if(ms.manga.title == mostRecent.manga.title){
        recents.remove(ms);
      }
    }

    mostRecent.manga.setChapter = Provider.of<MangaProvider>(context, listen: false).getCurrentChapterName;
    recents.add(mostRecent);
    box.put("recent", recents);
  }

  @override 
  Widget build(BuildContext context){
    return FutureBuilder<List<String>>(
            future: fetchImageLinks(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                setRecentsPage(context, snapshot.data ??[]);
                return Reader(snapshot.data ??[]);
                }
              return Center(child: CircularProgressIndicator());
            });
  }
}

class Reader extends StatelessWidget{

  List<String> _imageLinks; 

  Reader(this._imageLinks);

  @override 
  Widget build(BuildContext context){
    return Stack(children: [
                  InkWell(
                      onTap: () {
                        Provider.of<BarProvider>(context, listen: false)
                            .toggleShowAppBar();
                      },
                      child: Container(
                          child: ExtendedImageGesturePageView.builder(
                        itemBuilder: (context, index) {
                          String? currentUrl = _imageLinks[index];

                          return Container(
                            padding: EdgeInsets.all(5.0),
                            child: ExtendedImage.network(
                              currentUrl,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.gesture,
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          Provider.of<MangaProvider>(context, listen: false)
                              .setCurrentPageIndex = index;
                        },
                        itemCount: _imageLinks.length,
                        controller: PageController(initialPage: 0),
                        scrollDirection: Axis.horizontal,
                      ))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Provider.of<BarProvider>(context).showAppBar
                          ? Container(
                              height: AppBar().preferredSize.height,
                              color: Colors.grey.shade800,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${(Provider.of<MangaProvider>(context).getCurrentPageIndex + 1).toString()}/${_imageLinks.length.toString()}",
                                      style: TextStyle(
                                          color: Colors.grey.shade200),
                                    ),
                                  ],
                                ),
                              ))
                          : null)
                ]);
  }
}