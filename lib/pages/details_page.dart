import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_details_bloc.dart';
import 'package:flutter_manga_app_bloc/models/manga.dart';
import 'package:flutter_manga_app_bloc/models/manga_details.dart';
import 'package:flutter_manga_app_bloc/navigation/navigation.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_status.dart';
import 'package:flutter_manga_app_bloc/widgets/error_widget.dart';
import 'package:flutter_manga_app_bloc/widgets/loading_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailsPage extends StatefulWidget {
  final Manga manga;
  DetailsPage({Key key, this.manga}) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {
  MangaDetailsBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = MangaDetailsBloc();
  }
  @override
  Widget build(BuildContext context) {
    _bloc.fetchMangaDetails(widget.manga);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.manga.title,
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchMangaDetails(widget.manga),
        child: StreamBuilder<ApiResponse<MangaDetails>>(
          stream: _bloc.mangaDetailsStreams,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return Details(mangaDetails: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchMangaDetails(widget.manga),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}
class Details extends StatelessWidget {
  final MangaDetails mangaDetails;
  const Details({Key key, this.mangaDetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        backgroundImage(),
        backgroundFilter(),
        Column(
          children: [
            title(),
            coverImage(),
            actions(),
            Expanded(child: chapterList()),
          ],
        )
      ],
    );
  }
  Row actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        actionShare(),
        actionBookmark(),
      ],
    );
  }
  Padding actionBookmark() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: new Icon(
          Icons.bookmark,
          color: Colors.white,
        ),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: const Color(0xaa3C3261),
        ),
      ),
    );
  }
  Padding actionShare() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: new Icon(
          Icons.share,
          color: Colors.white,
        ),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          color: const Color(0xaa3C3261),
        ),
      ),
    );
  }
  Container title() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: new Row(
        children: [
          new Expanded(
            child: new Text(
              mangaDetails.title,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontFamily: 'Arvo',
              ),
            ),
          ),
        ],
      ),
    );
  }
  Container coverImage() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      alignment: Alignment.center,
      child: new Container(width: 400.0, height: 300.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        image: new DecorationImage(
          image: new NetworkImage(mangaDetails.coverUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          new BoxShadow(blurRadius: 20.0, offset: new Offset(0.0, 10.0))
        ],
      ),
    );
  }
  BackdropFilter backgroundFilter() {
    return BackdropFilter(
      // filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      filter: ImageFilter.blur(),
      child: new Container(
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }
  Image backgroundImage() {
    return Image.network(
      mangaDetails.coverUrl,
      fit: BoxFit.cover,
    );
  }
  GridView chapterList() {
    final navigation = Modular.get<Navigation>();
    return GridView.builder(
      itemCount: mangaDetails.chapters.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              navigation.goToViewer(mangaDetails.chapters[index]);
            },
            child: Container(
              // margin: const EdgeInsets.all(15.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Text(
                "Ch. ${mangaDetails.chapters[index].customName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  fontFamily: 'Arvo',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}