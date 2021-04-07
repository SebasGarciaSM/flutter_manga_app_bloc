import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/models/manga_details.dart';
import 'package:flutter_manga_app_bloc/models/manga_latest_response.dart';
import 'package:flutter_manga_app_bloc/models/manga_search.dart';
import 'package:flutter_manga_app_bloc/models/page_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MangaTownRepository {
  ApiBaseHelper _apiBaseHelper = Modular.get<ApiBaseHelper>();

  Future<List<Manga>> fetchLatestManga(int page) async {
    final response = await _apiBaseHelper.getHtml('latest/$page.htm');
    return MangaLatestResponse.fromHtml(page, response).results;
  }

  Future<List<Manga>> fetchSearchManga(String query) async {
    final response = await _apiBaseHelper.getHtml('search?name=$query');
    return MangaSearch.fromHtml(query, response).results;
  }

  Future<MangaDetails> fetchMangaDetails(Manga manga) async {
    final response = await _apiBaseHelper.getHtml(manga.link);
    return MangaDetails.fromHtml(manga, response);
  }

  Future<PageResponse> fetchPage(String link) async {
    final response = await _apiBaseHelper.getHtml(link);
    return PageResponse.fromHtml(link, response);
  }
}
