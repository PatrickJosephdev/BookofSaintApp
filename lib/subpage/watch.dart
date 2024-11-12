import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String saintName;
  final String videoUrl;

  const YoutubePlayerPage(
      {super.key, required this.saintName, required this.videoUrl});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Extract the video ID from the provided video URL
    String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    // Initialize the YoutubePlayerController with the extracted video ID
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '', // Use an empty string if videoId is null
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            // Optional: Add a listener if you want to listen for player events
            _controller.addListener(() {
              // Example: Print the player state
              if (_controller.value.isPlaying) {
                print("Video is playing");
              }
            });
          },
        ),
        builder: (context, player) {
          return Center(
            child: Column(
              children: [
                // Add any other widgets you want above the player
                Text("Now Playing: ${widget.saintName}"),
                const SizedBox(height: 20),
                player, // This is where the player is rendered
                // Add any other widgets you want below the player
              ],
            ),
          );
        },
      ),
    );
  }
}
