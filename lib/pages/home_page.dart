
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_modular/flutter_modular.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final navigation = Modular.get<Navigation>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manga App'),
      ),
      body: Container(
        child: Column(
          children: [
            FloatingActionButton(
              onPressed: () => navigation.goToDetails(),
            )
          ],
        ),
      ),
    );
  }
}