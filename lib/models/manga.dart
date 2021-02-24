import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Manga{

  String title;
  String link;
  String coverUrl;

  Manga({this.title, this.link, this.coverUrl});

  Manga.fromHtml(String html){

    dom.Document doc = parser.parse(html);

    final pTitle = doc.getElementsByClassName('title').first;
    final aTitle = pTitle.children.first;
    title = aTitle.attributes['title'];

    var temp = aTitle.attributes['href'];
    if(temp.startsWith('/'))
    {
      link = temp.substring(1);
    }
    else{
      link = temp;
    }

    final aCover = doc.getElementsByClassName('manga_cover').first;
    final img = aCover.children.first;
    coverUrl = img.attributes['src'];
  }
  
}