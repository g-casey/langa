import 'package:flutter/material.dart';
import 'package:manga/get_manga.dart';
import 'package:manga/manga.dart';
import 'package:manga/manga_screen.dart';
import 'package:manga/providers.dart';
import 'package:provider/provider.dart';

class MangaTile extends StatelessWidget {
  Manga _manga;
  MangaTile(this._manga);

  Future<void> onTap(BuildContext context, Manga manga) async {
    await Downloader.getFullManga(_manga);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MangaScreen(this._manga)));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_manga.title),
      subtitle: Text(_manga.views),
      trailing: Image.network(_manga.image),
      onTap: () => onTap(context, _manga),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemCount: Provider.of<MangaProvider>(context).getResults.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          if (Provider.of<MangaProvider>(context).getResults.length != 0) {
            return MangaTile(
                Provider.of<MangaProvider>(context).getResults[index]);
          } else {
            return Text("Error");
          }
        },
      ),
      color: Colors.white,
    );
  }
}
