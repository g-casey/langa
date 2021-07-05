import 'package:manga/manga.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

List<String> countryCodes = ["", "es", "ru", "de", "it", "br", "fr"];

class Downloader {
  final String _country;
  final String _name;
  final String _url;

  Downloader(String _country, this._name)
      : this._country = countryCodes.contains(_country) ? _country : "es",
        this._url = "https://$_country.ninemanga.com";

  Future<List<Document>> initiateSearch(String formattedUrl) async {
    List<Document> sources = [];
    Uri url = Uri.parse(_url + formattedUrl);
    var response = await http.get(url, headers: {"Accept-Language": "*"});

    Document document = parse(response.body);
    sources.add(document);
    List<Element> pageList = document.querySelectorAll("ul.pagelist > li > a");
    //removes top list of pages

    //TODO load elements from first page first before requesting next pages
    if (pageList.length > 0) {
      List<Element> pages = pageList.sublist(1, (pageList.length ~/ 2) - 1);
      for (Element page in pages) {
        var data = await http.get(Uri.parse(page.attributes["href"] ?? ""),
            headers: {"Accept-Language": "*"});
        sources.add(parse(data.body));
      }
    }

    print(sources.length);
    return sources;
  }

  Future<List<Manga>> search() async {
    List<Manga> results = [];
    String formattedName = _name.replaceAll(r" ", "+");
    String formattedUrl = "/search/?wd=$formattedName";

    List<Document> pages = await initiateSearch(formattedUrl);
    for (Document page in pages) {
      int bookCount = page.querySelectorAll("dl.bookinfo").length;
      for (int i = 0; i < bookCount; i++) {
        Manga manga = Manga(
            page.querySelectorAll("dl.bookinfo > dd > a.bookname")[i].innerHtml,
            page
                    .querySelectorAll("dl.bookinfo > dt > a")[i]
                    .attributes["href"] ??
                "Error",
            page
                    .querySelectorAll("dl.bookinfo > dt > a > img")[i]
                    .attributes["src"] ??
                "Error",
            page
                .querySelectorAll("dl.bookinfo > dd > a.chaptername")[i]
                .innerHtml,
            page.querySelectorAll("dl.bookinfo > dd > span")[i].innerHtml,
            page.querySelectorAll("dl.bookinfo > dd > p")[i].innerHtml);
        results.add(manga);
      }
    }
    print(results.length);

    return results;
  }

  //TODO BORUTO ERROR FIX
  static Future<void> getFullManga(Manga _manga) async {
    Uri url = Uri.parse(_manga.url + "?waring=1");
    var response = await http.get(url, headers: {"Accept-Language": "*"});
    Document document = parse(response.body);
    _manga.setAuthor =
        document.querySelector("[itemprop='author']")?.innerHtml ?? "";
    List<Element> genres = document.querySelectorAll("[itemprop='genre']  > a");
    if (genres.length != 0) {
      _manga.setGenres = genres.map((e) => e.innerHtml).toList();
    }
    _manga.setYear =
        document.querySelector("[itemprop='year']")?.innerHtml ?? "";
    List<String> chapterNames = document
        .querySelectorAll("ul.sub_vol_ul > li > a")
        .map((e) => e.innerHtml)
        .toList();
    List<String> chapterUrls = document
        .querySelectorAll("ul.sub_vol_ul > li > a")
        .map((e) =>
            e.attributes["href"] ?? "https://en.wikipedia.org/wiki/HTTP_404")
        .toList();
    List<String> chapterDates = document
        .querySelectorAll("ul.sub_vol_ul > li > span")
        .map((e) => e.innerHtml)
        .toList();

    List<Chapter> chapters = [];

    for (int i = 0; i < chapterNames.length; i++) {
      chapters.add(Chapter(chapterNames[i], chapterUrls[i], chapterDates[i]));
    }
    _manga.setChapters = chapters;
  }
}