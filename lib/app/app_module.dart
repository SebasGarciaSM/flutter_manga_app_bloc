//ADMINISTRA LA NAVEGACIÓN DE LAS PÁGINAS

import 'package:flutter/cupertino.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/navigation/routes.dart';
import 'package:flutter_manga_app_bloc/pages/details_page.dart';
import 'package:flutter_manga_app_bloc/pages/home_page.dart';
import 'package:flutter_manga_app_bloc/pages/viewer_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../main.dart';

class AppModule extends MainModule{

  @override
  List<Bind> get binds => [
    Bind((_) => Navigation())
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Routes.HOME.path, child: (_, __) => HomePage()),
    ModularRouter(Routes.DETAILS.path, child: (_, __) => DetailsPage()),
    ModularRouter(Routes.VIEWER.path, child: (_, __) => ViewerPage()),
  ];

  @override
  // Apunta al Widget padre
  Widget get bootstrap => MyApp();

}