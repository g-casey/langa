import 'package:hive/hive.dart';


part 'manga.g.dart';

@HiveType(typeId: 0 )
class Manga extends HiveObject{
  @HiveField(0)
  late String _title;
  @HiveField(1)
  late String _url;
  @HiveField(2)
  late String _imageUrl;
  @HiveField(3)
  late String _chapter;
  @HiveField(4)
  late String _views;
  @HiveField(5)
  late String _description;

  @HiveField(6)
  String? _author;
  @HiveField(7)
  String? _year;
  @HiveField(8)
  List<String>? _genres;
  @HiveField(9)
  List<Chapter>? _chapters;


  Manga(String _title, String _url, String _imageUrl, String _chapter, String _views, String _description){
    this._title = _title;
    this._url = _url;
    this._imageUrl = _imageUrl;
    this._chapter = _chapter; 
    this._views = _views; 
    this._description = _description;
  }


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

  set setChapter(String chapter){
    this._chapter = chapter;
  }

  get title => _title;
  get views => _views;
  get image => _imageUrl;
  get url => _url;
  get author => _author;
  get year => _year;
  get genres => _genres;
  get chapters => _chapters;
  get chapter => _chapter;
}

@HiveType(typeId: 2)
class MangaStorage extends HiveObject{
  @HiveField(0)
  late Manga _manga; 
  @HiveField(1)
  late List<String> _mangaImages;
  @HiveField(2)
  late int _currentPage; 

  MangaStorage(this._manga, this._mangaImages, this._currentPage);

  get manga => _manga; 
  get mangaImages => _mangaImages;
  get currentPage => _currentPage;
}

@HiveType(typeId: 1)
class Chapter extends HiveObject{
  @HiveField(0)
  String _title;
  @HiveField(1)
  String _url;
  @HiveField(2)
  String _date;

  Chapter(this._title, this._url, this._date);

  get title => _title;
  get url => _url;
  get date => _date;
}
