import 'package:flutter/material.dart';
import 'package:shikha_tycs/favourite/liked_status.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlaybackScreen extends StatefulWidget {
  final String videoUrl; // This is the Firebase URL
  final String title;
  final String description;
  final String thingsRequired;
  final String thumbnail;

  VideoPlaybackScreen({
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.thingsRequired,
    required this.thumbnail
  });

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error initializing video: $error');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}',style: TextStyle(fontFamily: "StardosStencil"),),
        backgroundColor: Colors.lightBlue,
      ),
      body: _isLoading
          ? _buildLoading()
          : _hasError
          ? _buildError()
          : _buildVideoContent(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.lightBlue),
          SizedBox(height: 16),
          Text("Loading video..."),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'Video failed to load',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          Text('Please check the video URL and try again.'),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(controller: _chewieController!),
            ),
          ),
          LikedStatus(videoId: widget.videoUrl,title: widget.title,description: widget.description,thumbnailUrl: widget.thumbnail,thingsRequired: widget.thingsRequired,),
          SizedBox(height: 16), // Add spacing between video and text
          Text(
            "Title: ${widget.title}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Description: ${widget.description}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Things Required: ${widget.thingsRequired}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add action for a button if needed
              Navigator.pop(context); // Example action: go back
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.lightBlue, // Background color
              backgroundColor: Colors.white, // Text color
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
