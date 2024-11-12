import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_screen.dart'; // navigate to details screen
import 'search_screen.dart'; // navigate to search screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  bool isLoading = false;
  int page = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Initial movie fetch
    _scrollController
        .addListener(_scrollListener); // Add listener to the scroll
  }

  Future<void> fetchMovies() async {
    if (isLoading) return; // Prevent multiple simultaneous requests

    setState(() {
      isLoading = true; // Start loading
    });

    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=all&page=$page'));

    if (response.statusCode == 200) {
      setState(() {
        movies.addAll(json.decode(response.body)); // Add new movies to the list
        page++; // Increment page for the next request
        isLoading = false; // Set loading to false after fetching
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchMovies(); // Load more movies when reached the end
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.black,
                  floating: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Movies',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 350,
                    child: movies.isNotEmpty
                        ? Image.network(
                            movies[0]['show']['image'] != null
                                ? movies[0]['show']['image']['medium']
                                : 'https://via.placeholder.com/150',
                            fit: BoxFit.fill,
                          )
                        : SizedBox.shrink(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: null,
                          child: Column(children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'My List',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ]),
                        ),
                        MaterialButton(
                          onPressed: null,
                          child: Column(children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Play',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ]),
                        ),
                        MaterialButton(
                          onPressed: null,
                          child: Column(children: <Widget>[
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Info',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'Continue Watching...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children:
                        List.generate((movies.length / 4).ceil(), (rowIndex) {
                      int startIndex = rowIndex * 4;
                      int endIndex = startIndex + 4;
                      List<dynamic> rowMovies = movies.sublist(startIndex,
                          endIndex > movies.length ? movies.length : endIndex);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: rowMovies.map<Widget>((movie) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                            movieId: movie['show']['id']),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.black,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          movie['show']['image'] != null
                                              ? movie['show']['image']['medium']
                                              : 'https://via.placeholder.com/150',
                                          fit: BoxFit.cover,
                                          width: 150.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            movie['show']['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (isLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
