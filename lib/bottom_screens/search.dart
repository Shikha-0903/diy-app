import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shikha_tycs/video/video_player_screen.dart';
import 'package:shikha_tycs/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchYouTube() async {
    final query = _searchController.text.trim(); // Trim any whitespace
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a search term.';
        _searchResults.clear();
      });
      return; // Exit the function if the search query is empty
    }

    final apiKey = api_key;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults.clear();
    });

    try {
      for (String channelId in channelIds) {
        if (_searchResults.length >= 10) break;

        final url = 'https://www.googleapis.com/youtube/v3/search?part=id,snippet&q=$query&type=video&channelId=$channelId&key=$apiKey&maxResults=10';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final List<dynamic> allResults = jsonData['items'];

          final craftKeywords = [
            'craft', 'diy', 'handmade', 'recycle', 'upcycle',
            'waste to use', 'reuse', 'project', 'creative',
            'art', 'home decor', 'paper', 'plastic', 'origami'
          ];

          final filteredResults = allResults.where((item) {
            final title = item['snippet']['title'].toLowerCase();
            final description = item['snippet']['description'].toLowerCase();
            return craftKeywords.any((keyword) =>
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Make DIY",style: TextStyle(fontFamily: "StardosStencil"),),
            backgroundColor: Colors.lightBlue,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.lightBlue,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: Container(
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.lightBlue,
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search DIY crafts",
                        prefixIcon: Icon(Icons.search, color: Colors.lightBlue),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      onSubmitted: (_) => _searchYouTube(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100], // Light blue background for the whole screen
              ),
              child: Column(
                children: [
                  // Results Area
                  if (_isLoading)
                    Center(child: CircularProgressIndicator(color: Colors.lightBlue,))
                  else if (_errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                        ),
                      ),
                    )
                  else if (_searchController.text.trim().isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Please enter a search term.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    else if (_searchResults.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No craft-related results found.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                    else
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/img.png'), // Add your background image
                            fit: BoxFit.cover,
                            opacity: 0.3, // Adjust the opacity as needed
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final videoId = _searchResults[index]['id']['videoId'];
                            final title = _searchResults[index]['snippet']['title'].toString();
                            final thumbnailUrl =
                            _searchResults[index]['snippet']['thumbnails']['default']['url'];
                            final description = _searchResults[index]["snippet"]["description"].toString();

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(thumbnailUrl),
                                ),
                                title: Text(
                                  title,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  final filteredRelatedVideos = _searchResults.where((video) => video['id']['videoId'] != videoId).toList();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(videoId: videoId, query: _searchController.text, relatedVideos: filteredRelatedVideos,title: title,description: description,thumbnailUrl: thumbnailUrl,),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
