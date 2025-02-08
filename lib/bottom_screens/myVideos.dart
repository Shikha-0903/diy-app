import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../video/user_playback_screen.dart';

class MyVideosScreen extends StatefulWidget {
  @override
  _MyVideosScreenState createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _deleteVideo(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('user_videos').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video deleted successfully'),backgroundColor: Colors.lightBlue,));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete video: $e'),backgroundColor: Colors.lightBlue,));
    }
  }

  Future<void> _showDeleteConfirmationDialog(String docId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Video',style: TextStyle(fontFamily: "StardosStencil"),),
          content: Text('Are you sure you want to delete this video?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.lightBlue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color: Colors.lightBlue),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVideo(docId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Videos',
          style: TextStyle(fontFamily: "StardosStencil"),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user_videos')
              .where('userId', isEqualTo: userId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No videos found.'));
            }

            final documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                final data = doc.data() as Map<String, dynamic>;

                final title = data['title'] ?? 'No Title';
                final description = data['description'] ?? 'No Description';
                final videoUrl = data['videoUrl'] ?? '';
                final thumbnailUrl = data['thumbnailUrl'] ?? '';
                final thingsRequired = data['thingsRequired'] ?? 'Not Specified';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlaybackScreen(
                          videoUrl: videoUrl,
                          title: title,
                          description: description,
                          thingsRequired: thingsRequired,
                          thumbnail: thumbnailUrl,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlue, // A darker shade of blue for contrast
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 10.0, // Increased elevation for a more pronounced shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: thumbnailUrl.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(thumbnailUrl),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color: Colors.grey[300],
                            ),
                            child: thumbnailUrl.isNotEmpty
                                ? null
                                : Center(
                              child: Icon(
                                Icons.videocam,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  description,
                                  style: TextStyle(color: Colors.white70),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white70, size: 16),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        thingsRequired,
                                        style: TextStyle(color: Colors.white70),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              _showDeleteConfirmationDialog(doc.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
