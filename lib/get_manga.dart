import 'package:manga/manga.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart';


List<String> countryCodes = ["", "es", "ru", "de", "it", "br", "fr"];

class Downloader {
  final String _country;
  final String _name;
  final String _url;

  Downloader(String _country, this._name)
      : this._country = countryCodes.contains(_country) ? _country : "es",
        this._url = "https://$_country.ninemanga.com";

  static Future<Document> _makeReqeuest(String url) async {
    //fix cors error
    Uri uri = Uri.parse("https://cors-anywhere.herokuapp.com/" + url);
    Response response = await get(uri, headers: {
      "Accept-Language": "*",
      "x-requested-with": "XMLHTTPREQUEST"
    });
    return parse(response.body);
  }

  Future<List<Document>> _initiateSearch(String formattedUrl) async {
    List<Document> sources = [];
    sources.add(await _makeReqeuest(_url + formattedUrl));
    //List<Element> pageList = document.querySelectorAll("ul.pagelist > li > a");
    //removes top list of pages

    //TODO load elements from first page first before requesting next pages
    /*if (pageList.length > 0) {
      List<Element> pages = pageList.sublist(1, (pageList.length ~/ 2) - 1);
      for (Element page in pages) {
        var data = await http.get(Uri.parse(page.attributes["href"] ?? ""),
            headers: {"Accept-Language": "*"});
        sources.add(parse(data.body));
      }
    }*/
    return sources;
  }

  Manga _getMangaFromSearch(Document page, int resultNum) {
    return Manga(
        page
            .querySelectorAll("dl.bookinfo > dd > a.bookname")[resultNum]
            .innerHtml,
        page
                .querySelectorAll("dl.bookinfo > dt > a")[resultNum]
                .attributes["href"] ??
            "Error",
        page
                .querySelectorAll("dl.bookinfo > dt > a > img")[resultNum]
                .attributes["src"] ??
            "Error",
        page
            .querySelectorAll("dl.bookinfo > dd > a.chaptername")[resultNum]
            .innerHtml,
        page.querySelectorAll("dl.bookinfo > dd > span")[resultNum].innerHtml,
        page.querySelectorAll("dl.bookinfo > dd > p")[resultNum].innerHtml);
  }

  Future<List<Manga>> search() async {
    List<Manga> results = [];
    String formattedName = _name.replaceAll(r" ", "+");
    String formattedUrl = "/search/?wd=$formattedName";

    List<Document> pages = await _initiateSearch(formattedUrl);
    for (Document page in pages) {
      int bookCount = page.querySelectorAll("dl.bookinfo").length;
      for (int i = 0; i < bookCount; i++) {
        results.add(_getMangaFromSearch(page, i));
      }
    }
    return results;
  }

  static Future<void> getFullManga(Manga _manga) async {
    Document document = await _makeReqeuest(_manga.url + "?waring=1");

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

  static Future<List<String>> getMangaImages(String chapterUrl) async {
    List<String> imageLinks = [];

    int pageNum = 1;
    String fixedUrl = chapterUrl.substring(0, chapterUrl.length - 5) + "-10-";
    Document document = await _makeReqeuest(fixedUrl + "$pageNum.html");

    //amount of indivual image pages
    int pageCount = int.parse(document
        .querySelectorAll("div.chnav")[0]
        .children[4]
        .children
        .last
        .innerHtml);

    //amount of pages of 10 images
    int groupCount = (pageCount.toDouble() / 10.0).ceil();

    while (pageNum <= groupCount) {
      if (pageNum > 1) {
        document = await _makeReqeuest(fixedUrl + "$pageNum.html");
      }

      int imageCount = 10;
      if (pageNum == groupCount) {
        imageCount = pageCount % 10;
      }
      for (int i = 1; i <= imageCount; i++) {
        String imageUrl =
            document.querySelector(".manga_pic_$i")?.attributes["src"] ??
                "https://www.computerhope.com/jargon/e/error.png";
        imageLinks.add(imageUrl);
      }
      pageNum++;
    }
    return imageLinks;
  }
}
