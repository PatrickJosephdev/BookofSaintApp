import 'package:flutter/material.dart';
import 'package:myapp/subpage/read.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the SaintDetailPage

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites added yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                String saintName = favorites[index];

                // Retrieve the saint details from SharedPreferences
                return FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    SharedPreferences prefs = snapshot.data!;
                    String? saintImage = prefs.getString('${saintName}_image');
                    String? saintStory = prefs.getString('${saintName}_story');
                    String? videoUrl = prefs.getString('${saintName}_video');

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0), // Padding
                      tileColor: Colors.grey[200], // Light grey background
                      leading: saintImage != null
                          ? Container(
                              height: 50.0, // Fixed height for image
                              width: 50.0, // Fixed width for image
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners (optional)
                                child: Image.network(saintImage),
                              ),
                            )
                          : null,
                      title: Text(
                        saintName,
                        overflow: TextOverflow.ellipsis, // Truncate with "..."
                      ),
                      subtitle: Text(
                        saintStory ?? 'No story available',
                        overflow: TextOverflow.ellipsis, // Truncate with "..."
                        maxLines: 1, // Limit to one line
                      ),
                      onTap: () {
                        // Navigate to SaintDetailPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaintDetailPage(
                              saintName: saintName,
                              saintImage: saintImage ?? '',
                              saintStory: saintStory ?? '',
                              videoUrl: videoUrl ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
