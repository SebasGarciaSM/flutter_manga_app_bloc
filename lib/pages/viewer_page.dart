import 'package:flutter/material.dart';
import 'package:flutter_manga_app_bloc/bloc/manga_viewer_bloc.dart';
import 'package:flutter_manga_app_bloc/models/chapter.dart';
import 'package:flutter_manga_app_bloc/models/manga_page.dart';
import 'package:flutter_manga_app_bloc/models/page_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_response.dart';
import 'package:flutter_manga_app_bloc/repositories/api_status.dart';
import 'package:flutter_manga_app_bloc/widgets/error_widget.dart';
import 'package:flutter_manga_app_bloc/widgets/loading_widget.dart';

class ViewerPage extends StatefulWidget {
  final Chapter chapter;
  ViewerPage({Key key, this.chapter}) : super(key: key);
  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  ViewerBloc _bloc;
  List<MangaPage> _pages;
  int currentPageIndex = 0;
  PageResponse currentPage;
  @override
  void initState() {
    super.initState();
    _pages = List<MangaPage>();
    _bloc = ViewerBloc();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.fetchPage(widget.chapter.link);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.chapter.name,
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchPage(widget.chapter.link),
        child: StreamBuilder<ApiResponse<PageResponse>>(
          stream: _bloc.viewerStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  currentPage = snapshot.data.data;
                  if (_pages.length == 0) {
                    _pages = currentPage.pages;
                  }
                  currentPageIndex = _pages.indexWhere((mangaPage) =>
                      mangaPage.link == currentPage.currentPageUrl);
                  return InkWell(
                    child: Viewer(pageResponse: snapshot.data.data),
                    onTap: () {
                      nextPage(context);
                    },
                  );
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchPage(widget.chapter.link),
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

  void nextPage(BuildContext context) {
    final nextIndex = currentPageIndex + 1;
    if (nextIndex == _pages.length) {
      //last page
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("Last page")),
      );
    } else {
      currentPageIndex = nextIndex;
      _bloc.fetchPage(_pages[currentPageIndex].link);
    }
  }
}

class Viewer extends StatelessWidget {
  final PageResponse pageResponse;
  const Viewer({Key key, this.pageResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      pageResponse.imageUrl,
      fit: BoxFit.fitWidth,
    );
  }
}
