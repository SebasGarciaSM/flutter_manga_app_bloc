import 'package:flutter_manga_app_bloc/models/chapter.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class MangaDetails {

  String title;
  String coverUrl;
  String description;
  String author;
  List<String> artist;
  String status;
  List<String> genres;
  List<Chapter> chapters;

  MangaDetails({this.title, this.coverUrl, this.chapters, this.description});

  MangaDetails.fromHtml(Manga manga, String html){
    this.title = manga.title;
    this.coverUrl = manga.coverUrl;

    dom.Document doc = parser.parse(html);

    final ulChapterList = doc.getElementsByClassName('chapter_list').first;
    chapters = List<Chapter>();

    final spanDescription = doc.getElementById('show').innerHtml.replaceAll('<a class="more" href="javascript:;" onclick="cut_hide()">HIDE</a>', '').replaceAll('&nbsp;', '');
    description = spanDescription.trim();
    
    final aAuthor = doc.getElementsByClassName('color_0077').first;
    author = aAuthor.innerHtml.trim();

    final classColor = doc.getElementsByClassName('color_0077');
    final artistList = classColor.getRange(1, classColor.length-1);
    artist = List<String>();
    artistList.forEach((element) {artist.add(element.innerHtml);});
    artist.forEach((element) {element.substring(1, element.length-1);});

    final divGenres = doc.getElementsByClassName('detail_info clearfix').first;
    final liGenres = divGenres.getElementsByTagName('li')[4];
    final listGenres = liGenres.getElementsByTagName('a');
    genres = List<String>();
    listGenres.forEach((element) {genres.add(element.innerHtml);});

    ulChapterList.children.forEach((element) {chapters.add(Chapter.fromHtml(manga.title, element.innerHtml));
    });
  }
}