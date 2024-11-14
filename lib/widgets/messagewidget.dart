import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Message extends StatelessWidget {
  final String imageUrl;
  final String videoUrl;
  final String title;

  const Message({
    Key? key,
    required this.imageUrl,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height:200,
      // Set a fixed width for each item
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            // Display the image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Button at the bottom
            Positioned(
              bottom: 0,
              left: 30,
              right: 30,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Watch Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}