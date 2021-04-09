import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/Model/MovieModel.dart';

import '../Data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = true;
  String searchQuery = "", previousSearch = "";
  final PagingController<int, Results> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(searchQuery,pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(String query, int pageKey) async {

    try {
      print(searchQuery);
      if(searchQuery != previousSearch){
        _pagingController.itemList = [];
      }
      previousSearch = searchQuery;
       final newItems = await Data.searchMovies(query: searchQuery,page: pageKey);

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
          padding: const EdgeInsets.symmetric(horizontal: 34,vertical: 10),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSearchField(),
            ),
            Expanded(
              child: PagedListView<int, Results>(
                pagingController: _pagingController,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<Results>(
                    itemBuilder: (context, item, index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(leading: Container(
                            width: 100,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: item.backdropPath,
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
                          ),title: Text(item.originalTitle,style: TextStyle(color: Colors.black)),subtitle: RatingBarIndicator(
                            rating: double?.tryParse(item.voteAverage.toString()) ?? 1,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 10,
                            itemSize: 10.0,
                            direction: Axis.horizontal,
                          ),trailing: IconButton(icon: Icon(Icons.arrow_forward_rounded)),),
                        ),
                        Divider(color: Colors.grey,)
                      ],
                    )),
              ),
            ),
          ],),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
        onSubmitted: (value){
         _pagingController.refresh();
          // or do whatever you want when you are done editing
          // call your method/print values etc
        }
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}