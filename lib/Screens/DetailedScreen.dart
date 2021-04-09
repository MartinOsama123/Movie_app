import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/Model/MovieModel.dart';


class DetailedScreen extends StatelessWidget {
  final Results movieResult;

  const DetailedScreen({Key key, this.movieResult}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.red),onPressed: (){Navigator.pop(context);},),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: CachedNetworkImage(
                  imageUrl:
                  movieResult.backdropPath,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            backgroundColor: Colors.red,
                          )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 34),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            movieResult.originalTitle,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(
                              Icons.aspect_ratio_outlined,
                              color: Colors.green,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBarIndicator(
                        rating: movieResult.voteAverage > 5 ? movieResult.voteAverage / 5 : movieResult.voteAverage,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 40),
                    child: Row(children: [
                      Column(
                        children: [
                          const  Text("Color"),
                     //     Text(movieResult.specifications.firstWhere((element) => element.specId == 1).valueNameEn,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          const  Text("Made In"),
                   //       Text(movieResult.specifications.firstWhere((element) => element.specId == 7).valueNameEn,style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Spacer()
                    ],),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Align(alignment: Alignment.centerLeft,child: const Text("Details")),
                  ),
                  Text(movieResult.overview)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
