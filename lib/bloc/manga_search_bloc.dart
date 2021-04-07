import 'dart:async';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/manga_town_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MangaSearchBloc extends Disposable {
  MangaTownRepository _mangaTownRepository;
  StreamController _mangaSearchController;

  StreamSink<ApiResponse<List<Manga>>> get mangaSearchSink =>
      _mangaSearchController.sink;
  Stream<ApiResponse<List<Manga>>> get mangaSearchStreams =>
      _mangaSearchController.stream.asBroadcastStream();

  MangaSearchBloc() {
    _mangaSearchController = StreamController<ApiResponse<List<Manga>>>();
    _mangaTownRepository = Modular.get<MangaTownRepository>();
  }

  fetchMangaSearch(String manga) async {
    mangaSearchSink
        .add(ApiResponse.loading('Fetching mangas searched'));
    try {
      List<Manga> mangaSearch =
          await _mangaTownRepository.fetchSearchManga(manga);
      mangaSearchSink.add(ApiResponse.completed(mangaSearch));
    } catch (e) {
      mangaSearchSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _mangaSearchController?.close();
  }
}
