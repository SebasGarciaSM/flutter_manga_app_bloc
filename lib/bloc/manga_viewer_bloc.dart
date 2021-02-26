import 'dart:async';

import 'package:flutter_manga_app_bloc/models/page_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/manga_town_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ViewerBloc extends Disposable{

  MangaTownRepository _mangaTownRepository;
  StreamController _viewerController;

  StreamSink<ApiResponse<PageResponse>> get viewerSink => _viewerController.sink;
  Stream<ApiResponse<PageResponse>> get viewerStream => _viewerController.stream;

  ViewerBloc(){
    _viewerController = StreamController<ApiResponse<PageResponse>>();
    _mangaTownRepository = Modular.get<MangaTownRepository>();
  }

  fetchPage(String link) async{
    viewerSink.add(ApiResponse.loading('Fetching page'));
    try{
      PageResponse pageResponse = await _mangaTownRepository.fetchPage(link);
      viewerSink.add(ApiResponse.completed(pageResponse));
    }
    catch(e){
      viewerSink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _viewerController?.close();
  }
  
}