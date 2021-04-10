import 'package:flutter/material.dart';
import 'package:movie_app/Model/DBModel.dart';
import 'package:movie_app/Model/MovieModel.dart';
import 'package:provider/provider.dart';

class LikeButtonWidget extends StatefulWidget{
  final Results movieResult;

  const LikeButtonWidget({Key key, this.movieResult}) : super(key: key);
  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {

  @override
  Widget build(BuildContext context) {

    return Consumer<Favorite>(

      builder: (context, value, child) {
       return FutureBuilder<List<Favorite>>(
          future: value.favorites(),
          builder: (context, snapshot) {

            return IconButton(
                icon: Icon(
                  snapshot.hasData && snapshot.data.where((element) => element.id == widget.movieResult.id).isNotEmpty   ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 15,
                ),
                onPressed: () {
                  if(snapshot.data.where((element) => element.id == widget.movieResult.id).isNotEmpty) {
                    value.deleteDog(widget.movieResult.id);
                  }else {
                    value.insertDog(Favorite(
                        id: widget.movieResult.id,
                        name: widget.movieResult
                            .originalTitle,
                        imageUrl: widget.movieResult
                            .backdropPath,
                        averageVote: widget.movieResult
                            .voteAverage));
                  }

                });
          },
        );
      },
    );
  }
}