import 'package:flutter/material.dart';
import 'package:myapp/subpage/watch.dart';

class SaintDetailPage extends StatefulWidget {
  final String saintName;
  final String saintImage;
  final String saintStory;
  final String videoUrl; // Add video URL if applicable

  const SaintDetailPage({
    super.key,
    required this.saintName,
    required this.saintImage,
    required this.saintStory,
    required this.videoUrl, // Add video URL if applicable
  });

  @override
  State<SaintDetailPage> createState() => _SaintDetailPageState();
}

class _SaintDetailPageState extends State<SaintDetailPage> {
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.saintName),
        centerTitle: true,
        

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(widget.saintImage),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.saintName,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(widget.saintStory),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle video playback, e.g., using a video player plugin
                  // Example:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YoutubePlayerPage(saintName: widget.saintName, videoUrl: widget.videoUrl),
                    ),
                  );
                },
                child: const Text('Watch Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
