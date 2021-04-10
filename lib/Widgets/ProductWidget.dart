import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/Model/MovieModel.dart';
import 'package:movie_app/Screens/DetailedScreen.dart';
import 'package:movie_app/Widgets/LikeButtonWidget.dart';

class ProductWidget extends StatefulWidget {
  final Results movieResult;

  ProductWidget({
    Key key,
    this.movieResult,
  }) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DetailedScreen(
                        movieResult: widget.movieResult,
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
                          imageUrl: widget.movieResult.backdropPath,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                                backgroundColor: Colors.red,
                              )),
                          errorWidget: (context, url, error) =>
                              Container(child: Image.asset("assets/download.png",fit: BoxFit.cover,)),
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
                              child: LikeButtonWidget(movieResult: widget.movieResult))),
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
                widget.movieResult.originalTitle,
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              )),
        ),
        Flexible(
          flex: 1,
          child: RatingBarIndicator(
            rating: double?.tryParse(widget.movieResult.voteAverage.toString()) ?? 1,
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
