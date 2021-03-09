
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/pages/login_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'app/app_module.dart';
import 'bloc/auth_bloc.dart';
import 'navigation/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ModularApp(module:AppModule()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.LOGIN.path,
          navigatorKey: Modular.navigatorKey,
          onGenerateRoute: Modular.generateRoute,
        ),
    );
  }
}
