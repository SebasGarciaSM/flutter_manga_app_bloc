import 'package:html/dom.dart';

class MangaPage {

  String name;
  String link;

  MangaPage({this.name, this.link});

  MangaPage.fromDomElement(Element option){
    
    name = option.text;

    String tempLink = option.attributes['value'];
    if(tempLink.startsWith('/'))
    {
      link = tempLink.substring(1);
    }
    else{
      link = tempLink;
    }

  }

}