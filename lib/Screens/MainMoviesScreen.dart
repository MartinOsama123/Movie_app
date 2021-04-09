import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/Model/MovieModel.dart';

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
      print(pageKey);
      if(isNowPlaying) {
         newItems = await Data.getNowPlaying(page: pageKey);
      }else {
        newItems = await Data.getTopRated(page: pageKey);
      }
      print(newItems);
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
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 8),
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
                      itemBuilder: (context, item, index) => ProductWidget(
                            movieResult: item,
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

class ProductWidget extends StatelessWidget {
  final Results movieResult;

  const ProductWidget({
    Key key,
    this.movieResult,
  }) : super(key: key);

  get productsModel => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: GestureDetector(
            onTap: () {
              print(movieResult.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DetailedScreen(
                            movieResult: movieResult,
                          )));
            },
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 500,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                          imageUrl: movieResult.backdropPath,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    backgroundColor: Colors.red,
                                  )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  onPressed: () {}))),
                    ))
              ],
            ),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                movieResult.originalTitle,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              )),
        ),
        Flexible(
          flex: 1,
          child: RatingBarIndicator(
            rating: double?.tryParse(movieResult.voteAverage.toString()) ?? 1,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 10,
            itemSize: 12.0,
            direction: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
