import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/Model/DBModel.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Favorite favorite = Provider.of<Favorite>(context);
    return Scaffold(
      body: FutureBuilder<List<Favorite>>(
        future: favorite.favorites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 100,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].imageUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    backgroundColor: Colors.red,
                                  )),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(snapshot.data[index].name,
                      style: TextStyle(color: Colors.black)),
                  subtitle: RatingBarIndicator(
                    rating: double?.tryParse(
                            snapshot.data[index].averageVote.toString()) ??
                        1,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 10,
                    itemSize: 10.0,
                    direction: Axis.horizontal,
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
