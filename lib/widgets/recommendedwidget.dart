import 'package:flutter/material.dart';

class Recommended extends StatelessWidget {
  final String saintName;
  final String celebrationDate;
  final String imageUrl;
  final VoidCallback onReadNow;

  const Recommended({
    super.key,
    required this.saintName,
    required this.celebrationDate,
    required this.imageUrl,
    required this.onReadNow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Load image from network or assets
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(31, 31, 30, 30),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saintName,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                celebrationDate,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 100),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 245, 241, 241),
                    backgroundColor: const Color.fromARGB(255, 2, 2, 2)
                        .withOpacity(0.8), // Text color
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Read Now",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
