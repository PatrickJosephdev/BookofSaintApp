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
      width: 150,
      height:150,
      // Set a fixed width for each item
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            // Display the image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Button at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: Text(title),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}