import 'package:flutter/material.dart';
import '../Data.dart';

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