import 'package:flutter_manga_app_bloc/navigation/routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Navigation{

  void goToDetails(){
    Modular.to.pushNamed(Routes.DETAILS.path);
  }

  void goToViewer(){
    Modular.to.pushNamed(Routes.VIEWER.path);
  }

}