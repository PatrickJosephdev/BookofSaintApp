import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/subpage/favorite.dart'; // Import the FavoritePage
import 'package:myapp/subpage/watch.dart'; // Import your YoutubePlayerPage

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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.saintName);
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      favorites.remove(widget.saintName);
      await prefs.setStringList('favorites', favorites);
    } else {
      favorites.add(widget.saintName);
      await prefs.setStringList('favorites', favorites);

      // Save saint details in SharedPreferences
      await prefs.setString('${widget.saintName}_image', widget.saintImage);
      await prefs.setString('${widget.saintName}_story', widget.saintStory);
      await prefs.setString('${widget.saintName}_video', widget.videoUrl);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.saintName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
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
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(widget.saintStory),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle video playback, e.g., using a video player plugin
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YoutubePlayerPage(
                        saintName: widget.saintName,
                        videoUrl: widget.videoUrl,
                      ),
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