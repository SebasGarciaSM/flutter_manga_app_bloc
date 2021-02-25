import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class Chapter{

  String link;
  String name;
  String customName;

  Chapter({this.link, this.name, this.customName});

  Chapter.fromHtml(title, String html){
    dom.Document document = parser.parse(html);
    final aChapter = document.getElementsByTagName('a').first;
    String tempLink = aChapter.attributes['href'];
    if(tempLink.startsWith('/')){
      link = tempLink.substring(1);
    }
    else{
      link = tempLink;
    }

    name = aChapter.text;
    customName = aChapter.text.replaceAll(title, '').trim();
  }

}