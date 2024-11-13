import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DailyMessage extends StatelessWidget {
  final String imageUrl;
  final String videoUrl;

  const DailyMessage({super.key, required this.imageUrl, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover, // Cover the entire container
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // A semi-transparent overlay to improve text visibility
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Watch Now',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  
                },
                child: const Text('Watch Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}