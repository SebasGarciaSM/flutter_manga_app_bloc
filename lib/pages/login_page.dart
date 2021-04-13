import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/auth_bloc.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    final navigation = Modular.get<Navigation>();
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((firebaseUser) {
      if (firebaseUser != null) {
        navigation.goToHome();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Provider(
      create: (context) => AuthBloc(),
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              onPressed: () => authBloc.loginGoogle(),
            ),
            SignInButton(
              Buttons.Facebook,
              onPressed: () => authBloc.loginFacebook(),
            ),
          ],
        ),
      )),
    );
  }
}
