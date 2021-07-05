class Manga {
  String _title;
  String _url;
  String _imageUrl;
  String _chapter;
  String _views;
  String _description;

  String? _author;
  String? _year;
  List<String>? _genres;
  List<Chapter>? _chapters;

  Manga(this._title, this._url, this._imageUrl, this._chapter, this._views,
      this._description);

  set setAuthor(String author) {
    _author = author;
  }

  set setYear(String year) {
    _year = year;
  }

  set setGenres(List<String> genres) {
    _genres = genres;
  }

  set setChapters(List<Chapter> chapters) {
    _chapters = chapters;
  }

  get title => _title;
  get views => _views;
  get image => _imageUrl;
  get url => _url;
  get author => _author;
  get year => _year;
  get genres => _genres;
  get chapters => _chapters;
}

class Chapter {
  String _title;
  String _url;
  String _date;

  Chapter(this._title, this._url, this._date);

  get title => _title;
  get url => _url;
  get date => _date;
}
