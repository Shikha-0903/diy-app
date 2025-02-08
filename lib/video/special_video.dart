import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shikha_tycs/favourite/liked_status.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen_s extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String thumbnail;

  const VideoPlayerScreen_s({Key? key, required this.videoId, required this.title, required this.description,required this.thumbnail})
      : super(key: key);

  @override
  State<VideoPlayerScreen_s> createState() => _VideoPlayerScreen_sState();
}

class _VideoPlayerScreen_sState extends State<VideoPlayerScreen_s> {
  late YoutubePlayerController _controller;
  bool _isFullscreen = false;

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
  }

  void _listener() {
    if (_controller.value.isFullScreen != _isFullscreen) {
      setState(() {
        _isFullscreen = _controller.value.isFullScreen;
      });
      if (_isFullscreen) {
        // Set orientation to landscape when fullscreen
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // Set orientation back to portrait when exiting fullscreen
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // Reset orientation to portrait on dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(
        title: Text("${widget.title}",style: TextStyle(fontFamily: "StardosStencil"),),
      ),
      body: SingleChildScrollView(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Player is ready.');
            },
          ),
          builder: (context, player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                LikedStatus(videoId: widget.videoId,title: widget.title,description: widget.description,thumbnailUrl: widget.thumbnail,thingsRequired: "",),
                if (!_isFullscreen)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("${widget.description}",style: TextStyle(fontSize: 20,fontFamily: "NotoSerif"),),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
