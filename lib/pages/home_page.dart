
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_bloc.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_status.dart';
import 'package:flutter_manga_app_bloc/widgets/error_widget.dart';
import 'package:flutter_manga_app_bloc/widgets/loading_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final mangaBloc = Modular.get<MangaBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manga App'),
      ),
      body: RefreshIndicator(
        onRefresh: () => mangaBloc.fetchMangaLatest(1),
        child: StreamBuilder<ApiResponse<List<Manga>>>(
          stream: mangaBloc.mangaListStreams,
          builder: (context, snapshot){
            if(snapshot.hasData)
            {
              switch(snapshot.data.status){
                case Status.LOADING   : return LoadingWidget(loadingMessage: snapshot.data.message); break;
                case Status.COMPLETED : return LatestManga(mangaList: snapshot.data.data); break;
                case Status.ERROR     : return Error(errorMessage: snapshot.data.message, onRetryPressed: () => mangaBloc.fetchMangaLatest(1)); break;
              }
            }
            return Container();
          },
        )
      ),
    );
  }
}

class LatestManga extends StatelessWidget{

  final List<Manga> mangaList;

  const LatestManga({Key key, this.mangaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final navigation = Modular.get<Navigation>();

    return GridView.builder(
      itemCount: mangaList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5/1.8
      ),
      itemBuilder: (context, index){
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