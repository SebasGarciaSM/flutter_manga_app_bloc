import 'dart:io' as response;

import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_search_bloc.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_status.dart';
import 'package:flutter_manga_app_bloc/widgets/error_widget.dart';
import 'package:flutter_manga_app_bloc/widgets/loading_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  MangaSearchBloc _bloc;

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _bloc = MangaSearchBloc();

    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    _bloc.fetchMangaSearch(query);

    return RefreshIndicator(
        onRefresh: () => _bloc.fetchMangaSearch(query),
        child: StreamBuilder<ApiResponse<List<Manga>>>(
          stream: _bloc.mangaSearchStreams,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return searchMangas(snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _bloc.fetchMangaSearch(query));
                  break;
              }
            }
            return Container();
          },
        ));
  }


  Widget searchMangas(List<Manga> mangaList) {
    final navigation = Modular.get<Navigation>();
    return ListView.builder(
      itemCount: mangaList.length,
        itemBuilder: (context, index) {
      return ListTile(
        leading: //Icon(Icons.book_online_rounded),
                  FadeInImage(
                                image: NetworkImage( mangaList[index].coverUrl),
                                placeholder: AssetImage('assets/img/no-image.jpg'),
                                width: 50.0,
                                fit: BoxFit.contain,
                              ),
        title: Text(mangaList[index].title),
        onTap: () {
          close(context, null);
          navigation.goToDetails(mangaList[index]);
        },
      );
    });
  }
}
