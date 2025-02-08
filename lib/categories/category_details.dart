import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:shikha_tycs/constants.dart';
import 'package:shikha_tycs/bottom_screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shikha_tycs/video/special_video.dart';
import 'package:shikha_tycs/bottom_navigation/Navigation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CategoryModel extends StatefulWidget {
  final String title;
  final String description;
  final List<String> imageUrls;
  final t_1,t_2,t_3,d_1,d_2,d_3;
  final String anime;


  const CategoryModel({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.t_1,required this.t_2,required this.t_3,required this.d_1,required this.d_2,required this.d_3,
    required this.anime
  }) : super(key: key);

  @override
  State<CategoryModel> createState() => _CategoryModelState();
}

class _CategoryModelState extends State<CategoryModel> {
  //List<String> videoUrls = [];
  List<Map<String, String>> videoDetails = []; // Declare videoDetails here
  bool isLoading = true; // Add a loading state to manage API requests

  void initState() {
    super.initState();
    if (videoDetails.isEmpty) {  // Only fetch video details if not already loaded
      fetchVideoUrls();
    } else {
      setState(() {
        isLoading = false; // Set loading to false if video details are already available
      });
    }
  }

  Future<void> fetchVideoDetailsFromYouTube(String videoId,String t) async {
    final url = 'https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$api_key&part=snippet';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'].isNotEmpty) {
          final videoData = data['items'][0]['snippet'];
          final title = t;
          final tt = videoData['title'];
          final description = videoData['description'];
          final thumbnailUrl = videoData['thumbnails']['default']['url']; // Get thumbnail URL

          print('Video Title: $title');
          print('Video Description: $description');

          // Store the video details in the state
          setState(() {
            videoDetails.add({
              'videoId': videoId,
              'title1': title,
              "title2": tt,
              'description': description,
              'thumbnailUrl': thumbnailUrl, // Store the thumbnail URL
            });
          });
        } else {
          print('No video data found');
        }
      } else {
        print('Failed to fetch video details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching video details: $e');
    }
  }

  Future<void> fetchVideoUrls() async {
    // Check if data for this category is already cached
    List<Map<String, String>>? cachedData = VideoCache().getVideoDetails(widget.title);
    if (cachedData != null && cachedData.isNotEmpty) {
      // Use cached data
      setState(() {
        videoDetails = cachedData;
        isLoading = false;  // Data is already available, no need to fetch again
      });
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;  // Start loading when fetching data
    });

    try {
      DocumentSnapshot snapshot = await firestore
          .collection('Category_videos')
          .doc('${widget.title}') // Sub-collection name
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> accessoryData = snapshot.data() as Map<String, dynamic>;

        for (var key in accessoryData.keys) {
          if (accessoryData[key] is Map<String, dynamic> && accessoryData[key].containsKey('videoId')) {
            String videoId = accessoryData[key]['videoId'];
            String t = accessoryData[key]["title"] ?? "${widget.title}";

            // Fetch video details from YouTube API for each videoId
            await fetchVideoDetailsFromYouTube(videoId, t);
          }
        }

        // Cache the video details after fetching them
        VideoCache().setVideoDetails(widget.title, videoDetails);

      } else {
        print("Document does not exist!");
      }
    } catch (e) {
      print("Error fetching video URLs: $e");
    } finally {
      setState(() {
        isLoading = false;  // Stop loading after fetching data
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontFamily: "StardosStencil",fontSize: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,
                      );
                    },
                    icon: Icon(Icons.home, size: 30, color: Colors.lightBlue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.lightBlue,
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        widget.description,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 30),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(widget.anime),
              // Images Section
              if (widget.imageUrls.isNotEmpty) ...[
                Text(
                  'See what you can make in ${widget.title}',
                  style: TextStyle(fontSize: 20,fontFamily: "NotoSerif"),
                ),
                const SizedBox(height: 10),
                _buildImageGrid(),
                const SizedBox(height: 20),
              ],

              // Videos Section

              if (videoDetails.isNotEmpty) ...[
                Text(
                  'Have a look',
                  style: TextStyle(fontSize: 20,fontFamily: "StardosStencil"),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.lightBlue,)) // Show a loading spinner while fetching data
                    :
                _buildVideoList(),
              ],
              Center(
                child: Column(
                  children: [
                    Text(
                      "Do you want to search for specific ${widget.title}?",
                      style: TextStyle(fontSize: 16, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.arrow_downward_outlined,color: Colors.lightBlue,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ));
                      },
                      child: Text(
                        "Search here",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        buildFactCard(widget.t_1, widget.d_1, Colors.lightBlue, Colors.teal),
                        buildFactCard(widget.t_2, widget.d_2, Colors.lightBlue, Colors.orange),
                        buildFactCard(widget.t_3, widget.d_3, Colors.lightBlue  , Colors.deepPurple),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // A GridView to show category images
  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return Container(
          width: 100, // Set a fixed width
          height: 100, // Set a fixed height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
            child: Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio
            ),
          ),
        );
      },
    );
  }

  // A ListView to show category videos
  Widget _buildVideoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: videoDetails.length,
      itemBuilder: (context, index) {
        final video = videoDetails[index];
        //final vId =video["videoId"];
        final videoThumbnailUrl = YoutubePlayer.getThumbnail(videoId: video["videoId"]!);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: videoThumbnailUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                videoThumbnailUrl!,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            )
                : Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Icon(Icons.play_circle_outline, size: 40),
            ),
            title: Text(
              video['title1']! ?? 'Video ${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoPlayerScreen_s(
                  videoId: video["videoId"]!,
                  title: video["title2"]!,
                  description: video["description"]!,
                  thumbnail: videoThumbnailUrl!,
                ),
              ));
            },
          ),
        );
      },
    );
  }
}

class VideoCache {
  static final VideoCache _instance = VideoCache._internal();
  factory VideoCache() => _instance;

  VideoCache._internal();

  // Store video details
  Map<String, List<Map<String, String>>> _videoDetailsCache = {};

  // Get cached data by category
  List<Map<String, String>>? getVideoDetails(String category) {
    return _videoDetailsCache[category];
  }

  // Store data for a category
  void setVideoDetails(String category, List<Map<String, String>> details) {
    _videoDetailsCache[category] = details;
  }
}
