//ADMINISTRA LA NAVEGACIÓN DE LAS PÁGINAS

import 'package:flutter/cupertino.dart';
import 'package:flutter_manga_app_bloc/bloc/auth_bloc.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_bloc.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/navigation/routes.dart';
import 'package:flutter_manga_app_bloc/pages/details_page.dart';
import 'package:flutter_manga_app_bloc/pages/home_page.dart';
import 'package:flutter_manga_app_bloc/pages/login_page.dart';
import 'package:flutter_manga_app_bloc/pages/viewer_page.dart';
import 'package:flutter_manga_app_bloc/repositories/api_helper.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/manga_town_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../main.dart';

class AppModule extends MainModule{

  @override
  List<Bind> get binds => [
    Bind((_) => AuthBloc()),
    Bind((_) => Navigation()),
    Bind((_) => ApiBaseHelper()),
    Bind((_) => MangaBloc()),
    Bind((_) => MangaTownRepository()),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Routes.LOGIN.path, child: (BuildContext context,__) => LoginPage()),
    ModularRouter(Routes.HOME.path, child: (_, __) => HomePage()),
    ModularRouter(Routes.DETAILS.path, child: (_, args) => DetailsPage(manga: args.data,)),
    ModularRouter(Routes.VIEWER.path, child: (_, args) => ViewerPage(chapter: args.data,)),
  ];

  @override
  // Apunta al Widget padre
  Widget get bootstrap => MyApp();

}