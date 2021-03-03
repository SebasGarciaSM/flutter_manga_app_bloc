import 'package:flutter_manga_app_bloc/models/chapter.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/navigation/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Navigation{

  void goToHome(){
    Modular.to.pushNamed(Routes.DETAILS.path);
  }

  void goToDetails(Manga manga){
    Modular.to.pushNamed(Routes.DETAILS.path, arguments: manga);
  }

  void goToViewer(Chapter chapter){
    Modular.to.pushNamed(Routes.VIEWER.path, arguments: chapter);
  }

}