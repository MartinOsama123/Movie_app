import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/Model/MovieModel.dart';

import '../Data.dart';
import 'DetailedScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "", previousSearch = "";
  bool _showClearButton = false;
  final PagingController<int, Results> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(searchQuery, pageKey);
    });
    _searchQueryController.addListener(() { setState(() {
      _showClearButton = _searchQueryController.text.length > 0;
    });});
    super.initState();
  }

  Future<void> _fetchPage(String query, int pageKey) async {
    try {
      if (searchQuery != previousSearch) {
        _pagingController.itemList = [];
      }
      previousSearch = searchQuery;
      final newItems =
          await Data.searchMovies(query: searchQuery, page: pageKey);

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSearchField(),
              ),
              if (searchQuery.isNotEmpty)
                Expanded(
                  child: PagedListView<int, Results>(
                    pagingController: _pagingController,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),

                    builderDelegate: PagedChildBuilderDelegate<Results>(
                      noItemsFoundIndicatorBuilder: (context) => Center(child: CircularProgressIndicator(),),
                        itemBuilder: (context, item, index) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DetailedScreen(
                                                    movieResult: item,
                                                  )));
                                    },
                                    child: ListTile(
                                      leading: Container(
                                        width: 100,
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              imageUrl: item.backdropPath,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    backgroundColor: Colors.red,
                                                  )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(child: Image.asset("assets/download.png",height: 500,width: 500,)),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      title: Text(item.originalTitle,
                                          style:
                                              TextStyle(color: Colors.black)),
                                      subtitle: RatingBarIndicator(
                                        rating: double?.tryParse(
                                                item.voteAverage.toString()) ??
                                            1,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 10,
                                        itemSize: 10.0,
                                        direction: Axis.horizontal,
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.arrow_forward_rounded),
                                        onPressed: () {Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    DetailedScreen(
                                                      movieResult: item,
                                                    )));},
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                )
                              ],
                            )),
                  ),
                )
              else
                Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
        controller: _searchQueryController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Search Data...",
          contentPadding: const EdgeInsets.all(20),

          suffixIcon: _getClearButton(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintStyle: TextStyle(color: Colors.grey),
        ),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      //  onChanged: (query) => updateSearchQuery(query),
        onSubmitted: (value) {
          updateSearchQuery(value);
          _pagingController.refresh();
        });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }
  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () => _searchQueryController.clear(),
      icon: Icon(Icons.clear),
    );
  }
}
