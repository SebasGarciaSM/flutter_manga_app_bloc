import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/auth_bloc.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_bloc.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/pages/login_page.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_status.dart';
import 'package:flutter_manga_app_bloc/search/search_delegate.dart';
import 'package:flutter_manga_app_bloc/widgets/error_widget.dart';
import 'package:flutter_manga_app_bloc/widgets/loading_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MangaBloc _bloc;
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    _bloc = MangaBloc();
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
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
    _bloc.fetchMangaLatest(1);
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Manga App'),
        actions: [
          MaterialButton(
              child: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () => authBloc.logout()),
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch(),
                // query: 'Hola'
                );
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => _bloc.fetchMangaLatest(1),
          child: StreamBuilder<ApiResponse<List<Manga>>>(
            stream: _bloc.mangaListStreams,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return LoadingWidget(loadingMessage: snapshot.data.message);
                    break;
                  case Status.COMPLETED:
                    return LatestManga(mangaList: snapshot.data.data);
                    break;
                  case Status.ERROR:
                    return Error(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () => _bloc.fetchMangaLatest(1));
                    break;
                }
              }
              return Container();
            },
          )),
    );
  }
}

class LatestManga extends StatelessWidget {
  final List<Manga> mangaList;

  const LatestManga({Key key, this.mangaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = Modular.get<Navigation>();

    return GridView.builder(
      itemCount: mangaList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 1.5 / 1.8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              navigation.goToDetails(mangaList[index]);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  mangaList[index].coverUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
