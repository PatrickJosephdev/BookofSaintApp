import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:myapp/model/apifetchdata.dart';
import 'package:myapp/subpage/read.dart';
import 'package:myapp/subpage/watch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SaintList extends StatefulWidget {
  const SaintList({super.key});

  @override
  State<SaintList> createState() => _SaintListState();
}

class _SaintListState extends State<SaintList> {
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;
  String _error = '';

  Future<void> loadData({bool forceRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // If forced refresh is true, fetch data from the API
    if (forceRefresh) {
      await _fetchAndSaveData(prefs);
    } else {
      // Check if data is already saved in Shared Preferences
      String? savedData = prefs.getString('saintList');

      if (savedData != null) {
        // If data exists, decode it and set it to _items and _filteredItems
        setState(() {
          _items = jsonDecode(savedData);
          _filteredItems = _items; // Initialize filtered items
          _isLoading = false;
        });
      } else {
        // If no data, fetch from API
        await _fetchAndSaveData(prefs);
      }
    }
  }

  Future<void> _fetchAndSaveData(SharedPreferences prefs) async {
    try {
      final data = await fetchData(); // Fetch data from the API
      setState(() {
        _items = data;
        _filteredItems = data; // Initialize filtered items
        _isLoading = false;
      });

      // Save fetched data to Shared Preferences
      await prefs.setString('saintList', jsonEncode(_items));
    } catch (error) {
      setState(() {
        _error = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(_items);

    if (_items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print(_items);
      return Scaffold(
          appBar: AppBar(
            title: const Text('Saint List'),
            actions: [
              SearchBarAnimation(
                textEditingController: textEditingController,
                searchBoxWidth: 300,
                isOriginalAnimation: true,
                trailingWidget: const Icon(Icons.search),
                secondaryButtonWidget: const Icon(Icons.cancel),
                buttonWidget: const Icon(Icons.search),
                hintText: "Search Here",
                onChanged: (value) {
                  // Handle search text change
                  _filteredItems = _items
                      .where((item) => item['name']
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {}); // Update UI with filtered results
                },
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Refresh data when pulled down
              await loadData(forceRefresh: true);
            },
            child: SingleChildScrollView(
              child: MasonryView(
                listOfItem: _filteredItems,
                numberOfColumn: calculateNumberOfColumns(context),
                itemRadius: 1,
                itemPadding: 5,
                itemBuilder: (item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(alignment: Alignment.center, children: [
                      Image.network(item['imageUrl'], fit: BoxFit.cover),
                      Positioned(
                          top: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              item['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )),
                      Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaintDetailPage(
                                        saintName: item['name'],
                                        saintImage: item['imageUrl'],
                                        saintStory: item['story'],
                                        videoUrl: item['videoUrl'],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black
                                      .withOpacity(0.3), // Text color
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                                child: const Text(
                                  "Read Now",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => YoutubePlayerPage(
                                          saintName: item['name'],
                                          videoUrl: item['videoUrl']),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black
                                      .withOpacity(0.3), // Text color
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                                child: const Text(
                                  "Play Now",
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                            ],
                          )),
                    ]),
                  );
                },
              ),
            ),
          ));
    }
  }

  int calculateNumberOfColumns(BuildContext context) {
    // Adjust this logic based on your desired minimum and maximum columns
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1000) return 6;
    if (screenWidth >= 900) return 5;
    if (screenWidth >= 600) return 4;
    if (screenWidth >= 400) return 3;
    if (screenWidth >= 300) return 2;

    return 1;
  }
}
