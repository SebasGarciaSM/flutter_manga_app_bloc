import 'dart:async';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/models/manga_details.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/manga_town_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MangaDetailsBloc extends Disposable{

  MangaTownRepository _mangaTownRepository;
  StreamController _mangaDetailsController;

  StreamSink<ApiResponse<MangaDetails>> get mangaDetailsSink => _mangaDetailsController.sink;
  Stream<ApiResponse<MangaDetails>> get mangaDetailsStreams => _mangaDetailsController.stream.asBroadcastStream();

  MangaDetailsBloc(){
    _mangaDetailsController = StreamController<ApiResponse<MangaDetails>>();
    _mangaTownRepository = Modular.get<MangaTownRepository>();
  }

  fetchMangaDetails(Manga manga) async{
    mangaDetailsSink.add(ApiResponse.loading('Fetching ${manga.title} details'));
    try{
      MangaDetails mangaDetails = await _mangaTownRepository.fetchMangaDetails(manga);
      mangaDetailsSink.add(ApiResponse.completed(mangaDetails));
    }
    catch(e){
      mangaDetailsSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _mangaDetailsController?.close();
  }
}