import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/Data.dart';
import 'package:movie_app/Model/DBModel.dart';
import 'package:movie_app/Model/MovieModel.dart';
import 'package:movie_app/Widgets/LikeButtonWidget.dart';


class DetailedScreen extends StatelessWidget {
  final Results movieResult;

  const DetailedScreen({Key key, this.movieResult}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white),onPressed: (){Navigator.pop(context);},),),
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
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
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
                        LikeButtonWidget(movieResult: movieResult,),
                      ],
                    ),
                  ),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: movieResult.voteAverage,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 10,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("(${movieResult.voteCount})",style: TextStyle(fontSize: 16)))
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GenresWidget(genresId: movieResult.genreIds,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Align(alignment: Alignment.centerLeft,child: const Text("Details",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),)),
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


class GenresWidget extends StatefulWidget {
  final genresId;
  const GenresWidget({
    Key key, this.genresId,
  }) : super(key: key);

  @override
  _GenresWidgetState createState() => _GenresWidgetState(genresId);
}

class _GenresWidgetState extends State<GenresWidget> {

  final genresId;

  _GenresWidgetState(this.genresId);

  Future<Map<int,String>> _fetchGenres() async {
    return await Data.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchGenres(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 45,
            child: ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(child:  Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                  child: Text(snapshot.data[genresId[index]]),
                )),
                    decoration: BoxDecoration(color: Colors.blueGrey,borderRadius: BorderRadius.circular(20))),
              );
            },shrinkWrap: true,scrollDirection: Axis.horizontal,itemCount: genresId.length,),
          ),
        );} else {
        return CircularProgressIndicator();
    }
      },

    );
  }
}
