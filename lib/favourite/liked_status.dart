import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shikha_tycs/constants.dart';

class LikedStatus extends StatefulWidget {
  final String videoId;
  final String title;          // Add title as a parameter
  final String thumbnailUrl;    // Add thumbnailUrl as a parameter
  final String description;
  final String thingsRequired;
  LikedStatus({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
    required this.thingsRequired
  });

  @override
  _LikedStatusState createState() => _LikedStatusState();
}

class _LikedStatusState extends State<LikedStatus> {
  bool isLiked = false; // Declare isLiked as a state variable

  @override
  void initState() {
    super.initState();
    loadLikeStatus(widget.videoId); // Load the like status when the screen is initialized
  }

  // Function to load the like status from SharedPreferences
  Future<void> loadLikeStatus(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? liked = prefs.getBool('liked_$videoId');
    setState(() {
      isLiked = liked ?? false; // Update the isLiked state with the stored value or false if null
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
      await _addToWishlist(widget.videoId, widget.title, widget.description,widget.thumbnailUrl ,widget.thingsRequired);
    } else {
      await _removeFromWishlist(widget.videoId); // Optionally handle removal from wishlist
    }
  }
  // Function to add video to wishlist
  Future<void> _addToWishlist(String videoId, String title, String description, String thumbnailUrl,String thingsRequired) async {
    try {
      await FirebaseFirestore.instance.collection('wishlist').add({
        'userId': userId,
        'videoId': videoId,
        'title': title,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'timestamp': FieldValue.serverTimestamp(),
        "thingsRequired" : thingsRequired
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
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border, // Show the like icon based on the state
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        toggleLikeStatus(widget.videoId); // Toggle like status when pressed
      },
    );
  }
}
