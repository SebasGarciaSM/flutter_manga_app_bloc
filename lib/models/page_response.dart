import 'package:flutter_manga_app_bloc/models/manga_page.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class PageResponse{

  List<MangaPage> pages;
  String currentPageUrl;
  String imageUrl;

  PageResponse({this.currentPageUrl, this.imageUrl, this.pages});

  PageResponse.fromHtml(String currentPageUrl, String html){

    this.currentPageUrl = currentPageUrl;

    dom.Document document = parser.parse(html);
    
    final img = document.getElementById('image');
    imageUrl = img.attributes['src'].replaceAll('//', 'http://');

    pages = List<MangaPage>();
    final selectPages = document.getElementsByClassName('page_select').first.children.last;
    selectPages.children.forEach((element) {
      if(!element.attributes['value'].toLowerCase().contains('feature')){
        pages.add(MangaPage.fromDomElement(element));
      }
    });

  }

}