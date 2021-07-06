import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:manga/manga.dart';
import 'package:manga/providers.dart';
import 'package:provider/provider.dart';

class ReaderScreen extends StatelessWidget {
  List<String> _imageLinks;

  ReaderScreen(this._imageLinks);

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
        body: Stack(children: [
          InkWell(
              onTap: () {
                Provider.of<BarProvider>(context, listen: false)
                    .toggleShowAppBar();
              },
              child: Container(
                  child: ExtendedImageGesturePageView.builder(
                itemBuilder: (context, index) {
                  String currentUrl = _imageLinks[index];

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
                              style: TextStyle(color: Colors.grey.shade200),
                            ),
                          ],
                        ),
                      ))
                  : null)
        ]));
  }
}
