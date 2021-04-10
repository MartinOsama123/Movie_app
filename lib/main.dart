import 'package:curved_bottom_navigation/curved_bottom_navigation.dart';

import 'package:flutter/material.dart';
import 'package:movie_app/Model/DBModel.dart';
import 'package:movie_app/Screens/FavoriteScreen.dart';
import 'package:movie_app/Screens/MainMoviesScreen.dart';
import 'package:movie_app/Screens/SearchScreen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Favorite.createDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Favorite(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: HomeNavigation(),
      ),
    );
  }
}
class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int navPos = 0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:
             Stack(
              children: [
              IndexedStack(
                  index: navPos,
                  children: [
                    NowPlayingScreen(isNowPlaying: true),
                    NowPlayingScreen(isNowPlaying: false),
                    SearchScreen(),
                    FavoriteScreen(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CurvedBottomNavigation(

                    selected: navPos,
                    onItemClick: (i) {
                      setState(() {
                        navPos = i;
                      });
                    },
                    items: [
                      Icon(Icons.movie, color: Colors.white),
                      Icon(Icons.trending_up, color: Colors.white),
                      Icon(Icons.search, color: Colors.white),
                      Icon(Icons.favorite, color: Colors.white),

                    ],
                  ),
                ),
              ],
      ));

  }
}
