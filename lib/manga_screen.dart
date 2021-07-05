import 'dart:ui';

import 'package:flutter/material.dart';

import 'manga.dart';

//TODO CLEAN WHOLE FILE MAKE SEPERATE WIDGETS

class MangaInfoDisplay extends StatelessWidget {
  Manga _manga;

  MangaInfoDisplay(this._manga);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _manga.image,
          fit: BoxFit.cover,
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              color: Colors.grey.shade900.withOpacity(0.6),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Image.network(
                        _manga.image,
                        height: 200.0,
                      )),
                  Flexible(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //TODO FIX TEXT OVERFLOW
                      Flexible(
                        child: Text(
                          _manga.title,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.shade200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 7),
                      Text(
                        _manga.author,
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 7),
                      Text(
                        _manga.year,
                        style: TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade200),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                          onPressed: () {},
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                          child: Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Text(
                              "Read",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey.shade200),
                            ),
                          ))
                    ],
                  )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class MangaChapterDisplay extends StatelessWidget {
  Manga _manga;
  MangaChapterDisplay(this._manga);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
            child: Column(
      children: [
        Flexible(
            flex: 1,
            child: Container(
                child: (_manga.genres != null)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _manga.genres?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            color: Colors.blueAccent,
                            child: Padding(
                              child: Text(
                                _manga.genres[index],
                                style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 14.0),
                              ),
                              padding: EdgeInsets.all(5.0),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.blue,
                        height: 0,
                      ))),
        (_manga.genres != null)
            ? Divider()
            : Container(
                color: Colors.blue,
                height: 0,
              ),
        Flexible(
            flex: 8,
            child: Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_manga.chapters[index].title),
                    trailing: Text(_manga.chapters[index].date),
                  );
                },
                itemCount: _manga.chapters.length,
                separatorBuilder: (context, index) => Divider(),
              ),
            ))
      ],
    )));
  }
}

class MangaScreen extends StatelessWidget {
  Manga _manga;

  MangaScreen(this._manga);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.grey.shade100)),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(child: MangaInfoDisplay(_manga)),
            (_manga.genres != null)
                ? Divider()
                : Container(
                    color: Colors.blue,
                    height: 0,
                  ),
            MangaChapterDisplay(_manga)
          ],
        ));
  }
}
