import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/models/manga_latest_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MangaTownRepository {

  ApiBaseHelper _apiBaseHelper = Modular.get<ApiBaseHelper>();

  Future<List<Manga>> fetchLatestManga(int page)async{
    
    final response = await _apiBaseHelper.getHtml('latest/$page.htm');
    return MangaLatestResponse.fromHtml(page, response).results;

  }

}