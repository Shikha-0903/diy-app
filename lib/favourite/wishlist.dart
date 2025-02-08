import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../video/special_video.dart';
import "package:shikha_tycs/video/user_playback_screen.dart";
class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late final String userId;

  void navigateToVideoPlayer(String videoUrl, String title, String description, String thumbnail, String thingsRequired) {
    // Check if thingsRequired is not null and not empty
    if (thingsRequired.isNotEmpty) {
      // Navigate to Chewie player for user-uploaded videos
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlaybackScreen(
            videoUrl: videoUrl,
            title: title,
            description: description,
            thumbnail: thumbnail,
            thingsRequired: thingsRequired, // Pass the thingsRequired field
          ),
        ),
      );
    } else {
      // Navigate to YouTube video player screen if thingsRequired is empty or null
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen_s(
            videoId: videoUrl, // Assuming it's a YouTube video ID or URL
            title: title,
            description: description,
            thumbnail: thumbnail,
          ),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    fetchUserId(); // Fetch userId when the page initializes
  }

  void fetchUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid; // Assign the userId if logged in
    } else {
      // Handle the case when the user is not logged in
      userId = ''; // Set userId to empty or handle accordingly
    }
  }

  Future<List<DocumentSnapshot>> fetchWishlistItems() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs; // Return the list of documents
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist',style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchWishlistItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your wishlist is empty.')); // No items in wishlist
          } else {
            List<DocumentSnapshot> wishlistItems = snapshot.data!; // Get the items from snapshot

            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                var item = wishlistItems[index];
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.network(item['thumbnailUrl']),
                        title: Text(item['title']),
                      ),
                    ),
                  ),
                  onTap: () {
                    String videoUrl = item["videoId"];
                    String title = item["title"];
                    String description = item["description"];
                    String thumbnail = item["thumbnailUrl"];
                    String thingsRequired = item["thingsRequired"]; // Use nullable type for thingsRequired

                    // Call navigateToVideoPlayer and pass the thingsRequired if available
                    navigateToVideoPlayer(videoUrl, title, description, thumbnail, thingsRequired);
                  },

                );
              },
            );
          }
        },
      ),
    );
  }
}
