import 'package:flutter/material.dart';
import 'package:myapp/widgets/saintcardwidget.dart';
import 'package:myapp/widgets/recommendedwidget.dart';
import 'package:myapp/model/apifetchdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import this to use jsonEncode and jsonDecode
import 'dart:async'; // Import this for Timer

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> saintList = [];
  bool _isLoading = true;
  String _error = '';
  Timer? _timer; // Timer to refresh data

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if data is already saved in Shared Preferences
    String? savedData = prefs.getString('saintList');

    if (savedData != null) {
      // If data exists, decode it and set it to saintList
      setState(() {
        saintList = jsonDecode(savedData);
        _isLoading = false;
      });
    } else {
      // If no data, fetch from API
      await _fetchDataAndSave(prefs);
    }
  }

  Future<void> _fetchDataAndSave(SharedPreferences prefs) async {
    try {
      final data = await fetchData();
      setState(() {
        saintList = data;
        _isLoading = false;
      });

      // Save fetched data to Shared Preferences
      await prefs.setString('saintList', jsonEncode(saintList));
    } catch (error) {
      setState(() {
        _error = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _fetchDataAndSave(prefs);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    startTimer(); // Start the timer when the widget is initialized
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (saintList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      List<String> dateParts = saintList[0]['celebrationDate'].split('-');

      String month = dateParts[0];
      String day = dateParts[1];

      return Scaffold(
        appBar: AppBar(
          title: const Text("SaintBook"),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Text(_error),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SaintCard(
                                saintName: saintList[0]['name'],
                                celebrationDate: "$day - $month",
                                imageUrl: saintList[0]['imageUrl'],
                                onReadNow: () {}),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Recommended",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                itemCount: saintList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final saint = saintList[index];
                                  return Recommended(
                                      saintName: saint['name'],
                                      celebrationDate: saint['celebrationDate'],
                                      imageUrl: saint['imageUrl'],
                                      onReadNow: () {});
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ]),
                    ),
                  ),
      );
    }
  }
}
