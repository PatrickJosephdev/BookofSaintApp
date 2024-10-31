import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:bookofsaints/model/apifetchdata.dart';

class SaintList extends StatefulWidget {
  const SaintList({super.key});

  @override
  State<SaintList> createState() => _SaintListState();
}

class _SaintListState extends State<SaintList> {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _error = '';

  Future<void> loadData() async {
    try {
      final data = await fetchData();
      setState(() {
        _items = data;
        print(_items);
        _isLoading = false;
      });
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
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(Icons.favorite),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: MasonryView(
              listOfItem: _items,
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Colors.black.withOpacity(0.3), // Text color
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Colors.black.withOpacity(0.3), // Text color
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
