import 'package:flutter_manga_app_bloc/models/chapter.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class MangaDetails {

  String title;
  String coverUrl;
  List<Chapter> chapters;

  MangaDetails({this.title, this.coverUrl, this.chapters});

  MangaDetails.fromHtml(Manga manga, String html){
    this.title = manga.title;
    this.coverUrl = manga.coverUrl;

    dom.Document doc = parser.parse(html);

    final ulChapterList = doc.getElementsByClassName('chapter_list').first;
    chapters = List<Chapter>();
    ulChapterList.children.forEach((element) {chapters.add(Chapter.fromHtml(manga.title, element.innerHtml));
    });
  }
}