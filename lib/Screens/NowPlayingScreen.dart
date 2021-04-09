import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/Model/MovieModel.dart';


import '../Data.dart';

class NowPlayingScreen extends StatefulWidget {

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {

  final PagingController<int, Results> _pagingController =
  PagingController(firstPageKey: 1);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();

  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      print(pageKey);
      final newItems = await Data.getNowPlaying(page: pageKey);
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
        body:   SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: PagedGridView<int, Results>(

                pagingController: _pagingController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                    crossAxisSpacing: 40.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.8),
                builderDelegate: PagedChildBuilderDelegate<Results>(
                    itemBuilder: (context, item, index) => ProductWidget(movieResult: item,)
                ),
              ),
            ),
          ),
        )

    );
  }
}

class ProductWidget extends StatelessWidget {
  final Results movieResult;

  const ProductWidget({
    Key key,
    this.movieResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            print(movieResult.id);
   //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailedScreen(product: productsModel,)));
          },
          child: Container(
            width: 150,
            height: 150,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                    imageUrl:
                    "https://image.tmdb.org/t/p/w780/${movieResult.backdropPath}",
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              backgroundColor: Colors.red,
                            )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill)),
          ),
        ),
        Spacer(),
        Align(
            alignment: Alignment.center,
            child: Text(
              movieResult.originalTitle,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            )),
        Row(
          children: [
            // Text("${productsModel.productPrice} L.E",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: AppColor.PrimaryColor),),
            // Spacer(),
            // IconButton(icon: Icon(Icons.add_shopping_cart,color: AppColor.PrimaryColor,), onPressed: () {})
          ],
        ),
        Spacer()
      ],
    );
  }
}
