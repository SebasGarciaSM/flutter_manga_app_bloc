import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class MangaSearch{

  String page;
  List<Manga> results;

  MangaSearch({this.page, this.results});

  MangaSearch.fromHtml(String page, String html){
    this.page = page;
    results = List<Manga>();

    dom.Document doc = parser.parse(html);

    final ulMangaList = doc.getElementsByClassName('manga_pic_list').first;
    ulMangaList.children.forEach((listItem) { results.add(Manga.fromHtml(listItem.innerHtml));});
  }
}
