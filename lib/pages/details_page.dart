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
      backgroundColor: Color.fromRGBO(244, 240, 240, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color.fromRGBO(69, 39, 160, 1.0)
          ),
        backgroundColor: Color.fromRGBO(244, 240, 240, 1.0),
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'Manga Reader',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(75, 75, 75, 1.0)
          ),
        ),
      ),
      body: ListView(
        children: [
            RefreshIndicator(
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
        ],
      ),
    );
  }
}
class Details extends StatelessWidget {
  final MangaDetails mangaDetails;
  const Details({Key key, this.mangaDetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            mangaImage(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  mangaTitle(),
                  SizedBox(height: 10.0),
                  startButton()
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10.0),
        mangaDescription(),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Details',
                      style: new TextStyle(
                      color: Color.fromRGBO(69, 39, 160, 1.0),
                      fontSize: 12.0,
                      fontFamily: 'Arial',
                    )
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Author: ${mangaDetails.author}', 
                    style: new TextStyle(
                      color: Color.fromRGBO(129, 128, 127, 1.0),
                      fontSize: 12.0,
                      fontFamily: 'Arial',
                    )
                  ),
                  getGenres(mangaDetails.genres)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Artist: ', 
                    style: new TextStyle(
                      color: Color.fromRGBO(129, 128, 127, 1.0),
                      fontSize: 12.0,
                      fontFamily: 'Arial',
                    )
                  ),
                  getArtists(mangaDetails.artist),
                ],
              ),
              Row(
                children: [
                  Text('Status: Ongoing', 
                    style: new TextStyle(
                      color: Color.fromRGBO(129, 128, 127, 1.0),
                      fontSize: 12.0,
                      fontFamily: 'Arial',
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
        /*Row(
          children: [
            Container(
              height: 15.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(129, 128, 127, 1.0),
                  ),
            ),
          ],
        ),*/
        Container(
          child: Column(
            children: [
              chapterList()
            ],
          ),
        )
      ],
    );
  }

  Container mangaDescription() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Text(mangaDetails.description,
          style: new TextStyle(
            color: Color.fromRGBO(129, 128, 127, 1.0),
            fontSize: 12.0,
            fontFamily: 'Arial',
          )
        )
      );
  }

  Container mangaImage() {
    return Container(
            padding: EdgeInsets.only(top: 10.0),
            alignment: Alignment.topLeft,
            child: Image(
              image:  NetworkImage(mangaDetails.coverUrl),
              height: 210.0,
              width: 170.0,
            ),
    );
  }

  Row mangaTitle() {
    return Row(
      children: [
        SizedBox(width: 10.0,),
        Expanded(
          child: Text(mangaDetails.title, softWrap: true,
            style: new TextStyle(
              color: Color.fromRGBO(69, 39, 160, 1.0),
              fontSize: 20.0,
              fontFamily: 'Arial',
            ),
          ),
        ),
      ],
    );
  }

  Row startButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 75.0,
          height: 75.0,
          child: FloatingActionButton.extended(
            label: Text('Start'),
            backgroundColor: Color.fromRGBO(248, 160, 15, 1.0),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  ListView chapterList() {
    final navigation = Modular.get<Navigation>();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mangaDetails.chapters.length,
      
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {
              navigation.goToViewer(mangaDetails.chapters[index]);
            },
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              //margin: const EdgeInsets.symmetric(horizontal:10.0),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Chapter ${mangaDetails.chapters[index].customName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(129, 128, 127, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontFamily: 'Arvo',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getArtists(List<String> strings)
  {
    return new Row(
      children: strings.map(
        (item) => new Text(
          item.trim(), style: new TextStyle(color: Color.fromRGBO(129, 128, 127, 1.0),fontSize: 12.0, fontFamily: 'Arial',
         )
        )
      ).toList()
    );
  }

  Widget getGenres(List<String> strings)
  {
    return new Row(
      children: strings.map((item) => new Text('${item.trim()}, ')).toList()
    );
  }
  
}