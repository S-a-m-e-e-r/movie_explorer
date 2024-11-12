import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_explorer/Screeens/details_screen.dart';
import 'dart:convert';

import 'package:movie_explorer/Screeens/home_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  TextEditingController _searchController = TextEditingController();

  Future<void> searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: Text(
          'Search Movies',
          style: TextStyle(color: Colors.white), // White text for title
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()), // Navigate to HomeScreen
            );
          },
        ),

        backgroundColor: Colors.black, // Black AppBar background
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style:
                  TextStyle(color: Colors.white), // White text color for input
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: TextStyle(color: Colors.white70), // Light hint text
                prefixIcon: Icon(Icons.search,
                    color: Colors.white), // White search icon
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70), // Light border
                ),
              ),
              onSubmitted: (query) {
                searchMovies(query);
              },
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                          color: Colors.white), // White text for "No results"
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var movie = searchResults[index]['show'];
                      return ListTile(
                        leading: Image.network(
                          movie['image'] != null
                              ? movie['image']['medium']
                              : 'https://via.placeholder.com/150',
                        ),
                        title: Text(
                          movie['name'],
                          style: TextStyle(
                              color: Colors.white), // White text for movie name
                        ),
                        subtitle: Text(
                          movie['summary'] != null
                              ? movie['summary'].replaceAll(
                                  RegExp(r'<[^>]*>'), '') // Remove HTML tags
                              : 'No summary available',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white70), // Light color for summary
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(movieId: movie['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
