import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'video_player_screen.dart'; // Ensure this imports the correct file
import 'package:shared_preferences/shared_preferences.dart'; // Add shared_preferences
import 'dart:async';

class CustomVideoPlayer extends StatefulWidget {
  final String query;
  final List<String> craftKeywords;
  final String t1;
  final String d1;
  final String t2;
  final String d2;
  final String t3;
  final String d3;

  const CustomVideoPlayer({
    Key? key,
    required this.query,
    required this.craftKeywords,
    required this.t1,
    required this.d1,
    required this.t2,
    required this.d2,
    required this.t3,
    required this.d3,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool isLiked = false;

  // Define a method to get cache key based on the query
  String _getCacheKey(String query) {
    return 'youtube_search_cache_${query.toLowerCase()}';
  }

  Future<void> _searchYouTube() async {
    final apiKey = api_key;
    final cacheKey = _getCacheKey(widget.query);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults.clear();
    });

    // Check if cached data is available
    if (prefs.containsKey(cacheKey)) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        setState(() {
          _searchResults = jsonDecode(cachedData);
          _isLoading = false;
        });
        return; // Use cached data, no need to fetch again
      }
    }

    // If no cached data, make API call
    try {
      for (String channelId in channelIds) {
        if (_searchResults.length >= 10) break;

        final url = 'https://www.googleapis.com/youtube/v3/search?part=id,snippet&q=${Uri.encodeComponent(widget.query)}&type=video&channelId=$channelId&key=$apiKey&maxResults=10';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final List<dynamic> allResults = jsonData['items'];

          final filteredResults = allResults.where((item) {
            final title = item['snippet']['title'].toLowerCase();
            final description = item['snippet']['description'].toLowerCase();
            return widget.craftKeywords.any((keyword) =>
            title.contains(keyword) && description.contains(keyword));
          }).toList();

          setState(() {
            _searchResults.addAll(filteredResults);
          });

          if (_searchResults.length >= 10) {
            _searchResults = _searchResults.sublist(0, 10);
            break;
          }
        } else if (response.statusCode == 403) {
          setState(() {
            _errorMessage = '403 Forbidden: Check your API key and quota limits.';
          });
          break;
        } else {
          setState(() {
            _errorMessage = 'Error loading search results: ${response.statusCode} ${response.reasonPhrase}';
          });
          break;
        }
      }

      // Cache the results if API call is successful
      if (_searchResults.isNotEmpty) {
        prefs.setString(cacheKey, jsonEncode(_searchResults));
      }

    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading search results: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchYouTube();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.query}',style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.lightBlue,))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _searchResults.isEmpty
          ? Center(child: Text('No craft-related results found'))
          : SingleChildScrollView( // Wrap in SingleChildScrollView to allow scrolling
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      final videoId = _searchResults[index]['id']['videoId'];
                      final title = _searchResults[index]['snippet']['title'];
                      final thumbnailUrl = _searchResults[index]['snippet']['thumbnails']['default']['url'];
                      final description = _searchResults[index]["snippet"]["description"];

                      return GestureDetector(
                        onTap: () {
                          final filteredRelatedVideos = _searchResults.where((video) => video['id']['videoId'] != videoId).toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoId: videoId,
                                query: widget.query,
                                relatedVideos: filteredRelatedVideos,
                                title: title,
                                description: description,
                                thumbnailUrl: thumbnailUrl,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          shadowColor: Colors.lightBlue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                thumbnailUrl,
                                width: double.infinity,
                                height: 120.0,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buildFactCard(
                        widget.t1,
                        widget.d1,
                        Colors.lightBlue,
                        Colors.teal
                    ),
                    buildFactCard(
                        widget.t2,
                        widget.d2,
                        Colors.lightBlue,
                        Colors.purple
                    ),
                    buildFactCard(
                        widget.t3,
                        widget.d3,
                        Colors.lightBlue,
                        Colors.greenAccent
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
