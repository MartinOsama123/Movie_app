import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/Model/MovieModel.dart';
import 'package:movie_app/Widgets/LikeButtonWidget.dart';
import 'package:movie_app/Widgets/ProductWidget.dart';

import '../Data.dart';
import 'DetailedScreen.dart';

class NowPlayingScreen extends StatefulWidget {
  final bool isNowPlaying;

  const NowPlayingScreen({Key key, this.isNowPlaying}) : super(key: key);
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState(isNowPlaying);
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final bool isNowPlaying;
  final PagingController<int, Results> _pagingController =
      PagingController(firstPageKey: 1);

  _NowPlayingScreenState(this.isNowPlaying);

  var data;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }


  Future<void> _fetchPage(int pageKey) async {
    var newItems;
    try {

      if(isNowPlaying) {
         newItems = await Data.getNowPlaying(page: pageKey);
      }else {
        newItems = await Data.getTopRated(page: pageKey);
      }
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(34, 10, 34, 100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(isNowPlaying ? "Now Playing in Cinemas" : "Top Trending All Time",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: PagedGridView<int, Results>(
                  pagingController: _pagingController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                      crossAxisSpacing: 40.0,
                      mainAxisSpacing: 30.0,
                      childAspectRatio: 0.8),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  builderDelegate: PagedChildBuilderDelegate<Results>(
                      itemBuilder: (context, item, index) => FutureBuilder(
                        future: data,
                        builder: (context, snapshot) {
                            return ProductWidget(
                              movieResult: item,
                            );
                        },
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

