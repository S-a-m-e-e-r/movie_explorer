import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsScreen extends StatefulWidget {
  final int movieId;

  DetailsScreen({required this.movieId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic> movieDetails = {};

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows/${widget.movieId}'));

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: Text(
          movieDetails['name'] ?? 'Movie Details',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.black, // Black background for AppBar
        iconTheme: IconThemeData(color: Colors.white), // White icons
      ),
      body: movieDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      movieDetails['image'] != null
                          ? movieDetails['image']['original']
                          : 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      movieDetails['name'] ?? 'No Title',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Genres: ${movieDetails['genres'].join(', ')}',
                      style: TextStyle(
                          color: Colors.white70), // Light color for text
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Premiered: ${movieDetails['premiered'] ?? 'Not Available'}',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white70),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Summary:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      movieDetails['summary'] != null
                          ? movieDetails['summary'].replaceAll(
                              RegExp(r'<[^>]*>'), '') // Remove HTML tags
                          : 'No summary available.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 16.0),
                    movieDetails['cast'] != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cast:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 8.0),
                              ...movieDetails['cast'].map<Widget>((actor) {
                                return Text(
                                  actor['person']['name'],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                );
                              }).toList(),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
