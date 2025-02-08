import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VideoPlayerScreen extends StatefulWidget {
  String videoId;
  final String query;
  List<dynamic> relatedVideos;
  String title;
  String description;
  String thumbnailUrl;

  VideoPlayerScreen({required this.videoId, required this.query, required this.relatedVideos,required this.title,required this.description,required this.thumbnailUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullscreen = false;
  bool isLiked = false; // To track the like status of the video

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _controller.addListener(_listener);

    // Fetch related videos
    fetchRelatedVideos(widget.videoId);

    // Load the like status for the initial video
    loadLikeStatus(widget.videoId);
  }

  void _listener() {
    if (_controller.value.isFullScreen != _isFullscreen) {
      setState(() {
        _isFullscreen = _controller.value.isFullScreen;
      });
      if (_isFullscreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Reset orientation to portrait
    super.dispose();
  }

  Future<List<dynamic>?> fetchFromYouTubeAPI(String videoId) async {
    final String url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&relatedToVideoId=$videoId&type=video&key=$api_key';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> relatedVideos = jsonResponse['items'];
        return relatedVideos;
      } else {
        print('Failed to load related videos. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching related videos: $e');
      return null;
    }
  }

  Future<void> fetchRelatedVideos(String videoId) async {
    List<dynamic>? cachedVideos = await loadRelatedVideosFromCache(videoId);

    if (cachedVideos != null) {
      setState(() {
        widget.relatedVideos = cachedVideos;
      });
    } else {
      final response = await fetchFromYouTubeAPI(videoId);

      if (response != null) {
        setState(() {
          widget.relatedVideos = response;
        });
        await cacheRelatedVideos(videoId, response);
      }
    }
  }

  Future<void> cacheRelatedVideos(String videoId, List<dynamic> relatedVideos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cachedData = json.encode(relatedVideos);
    await prefs.setString(videoId, cachedData);
  }

  Future<List<dynamic>?> loadRelatedVideosFromCache(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(videoId);
    if (cachedData != null) {
      return json.decode(cachedData);
    }
    return null;
  }

  // Function to load the like status from SharedPreferences
  Future<void> loadLikeStatus(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? liked = prefs.getBool('liked_$videoId');
    setState(() {
      isLiked = liked ?? false;
    });
  }

  // Function to toggle the like status and store it in SharedPreferences
  Future<void> toggleLikeStatus(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = !isLiked; // Toggle the isLiked state
    });
    await prefs.setBool('liked_$videoId', isLiked); // Store the new like status in SharedPreferences

    if (isLiked) {
      await _addToWishlist(widget.videoId, widget.title, widget.description, widget.thumbnailUrl);
    } else {
      await _removeFromWishlist(widget.videoId); // Optionally handle removal from wishlist
    }
  }
  // Function to add video to wishlist
  Future<void> _addToWishlist(String videoId, String title, String description, String thumbnailUrl) async {
    final videoThumbnailUrl = YoutubePlayer.getThumbnail(videoId: videoId!);
    try {
      await FirebaseFirestore.instance.collection('wishlist').add({
        'userId': userId,
        'videoId': videoId,
        'title': title,
        'description': description,
        'thumbnailUrl': videoThumbnailUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'thingsRequired' : ""
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Wishlist'), backgroundColor: Colors.lightBlue));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add to Wishlist: $e'), backgroundColor: Colors.red));
    }
  }

  // Function to remove video from wishlist (optional)
  // Function to remove video from wishlist
  Future<void> _removeFromWishlist(String videoId) async {
    try {
      // Query the wishlist collection to find the document with the given videoId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('videoId', isEqualTo: videoId)
          .where('userId', isEqualTo: userId) // Ensure it’s the user’s wishlist
          .get();

      // Check if any documents were found
      if (snapshot.docs.isNotEmpty) {
        // If found, delete the first matching document
        await snapshot.docs[0].reference.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video removed from wishlist'), backgroundColor: Colors.lightBlue));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video not found in wishlist'), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete video: $e'), backgroundColor: Colors.red));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(
        title: Text("${widget.query}",style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
          },
        ),
        builder: (context, player) {
          return Column(
            children: [
              // Video Player widget
              player,
              // Like button
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  // Toggle the like status when clicked
                  toggleLikeStatus(widget.videoId);
                },
              ),
              // Only show related videos if not in fullscreen mode
              if (!_isFullscreen)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.relatedVideos.length,
                    itemBuilder: (context, index) {
                      final videoId1 = widget.relatedVideos[index]['id']['videoId'];
                      final title1 = widget.relatedVideos[index]['snippet']['title'].toString();
                      final description1 = widget.relatedVideos[index]["snippet"]["description"].toString();
                      final thumbnailUrl1 = widget.relatedVideos[index]['snippet']['thumbnails']['default']['url'].toString();

                      // Skip the currently playing video

                      return Card(
                        child: ListTile(
                          leading: Image.network(thumbnailUrl1),
                          title: Text(title1),
                          onTap: () async {
                            // When a new video is tapped, load that video
                            _controller.load(videoId1);
                            // Reset the like state and load the like status for the new video
                            setState(() {
                              isLiked = false; // Reset the like status
                              widget.title = title1;
                              widget.videoId = videoId1;
                              widget.description = description1;
                              widget.thumbnailUrl = thumbnailUrl1;
                            });
                            // Fetch and update the like status for the new video
                            await loadLikeStatus(widget.videoId);

                            // Fetch new related videos for the newly loaded video
                            await fetchRelatedVideos(widget.videoId);
                          },
                        ),
                      );
                    },
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}



