import 'dart:async';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/manga_town_repository.dart';
import 'package:flutter_modular/flutter_modular.dart' show Disposable, Modular;

class MangaBloc extends Disposable{

  MangaTownRepository _mangaTownRepository;
  StreamController _mangaListController;

  StreamSink<ApiResponse<List<Manga>>> get mangaListSink => _mangaListController.sink;
  Stream<ApiResponse<List<Manga>>> get mangaListStreams => _mangaListController.stream;

  MangaBloc(){
    _mangaListController = StreamController<ApiResponse<List<Manga>>>();
    _mangaTownRepository = Modular.get<MangaTownRepository>();
    fetchMangaLatest(1);
  }

  fetchMangaLatest(int page) async{
    mangaListSink.add(ApiResponse.loading('Fetching latest realeases'));
    try{
      List<Manga> latestManga = await _mangaTownRepository.fetchLatestManga(page);
      mangaListSink.add(ApiResponse.completed(latestManga));
    }
    catch(e){
      mangaListSink.add(ApiResponse.error(e.toString()));
    }
  }


  @override
  void dispose() {
    _mangaListController?.close();
  }

}