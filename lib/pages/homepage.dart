import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/model/fetchdailymass.dart';
import 'package:myapp/subpage/read.dart';
import 'package:myapp/widgets/dailymasswidget.dart';
import 'package:myapp/widgets/messagewidget.dart';
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
  List<dynamic> massList = [];
  List<dynamic> dailymessageList = [];
  bool _isLoading = true;
  String _error = '';
  Timer? _timer; // Timer to refresh data

  Future<void> _fetchMessageData() async {
    try {
      final messageList = await massData(
          "https://patrickjosephdev.github.io/Book_of_Saints/dailymessage.json");
      setState(() {
        dailymessageList = messageList;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMassData() async {
    try {
      final massDataList = await massData(
          "https://patrickjosephdev.github.io/Book_of_Saints/dailymass.json");
      setState(() {
        massList = massDataList;
        _isLoading = false;
        print(massList[0]['imageUrl']);
      });
    } catch (error) {
      setState(() {
        _error = 'Error: $error';
        _isLoading = false;
      });
    }
  }

// code for saint loaddata

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

// code for saint fetch and save

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
    startTimer();
    _fetchMassData();
    _fetchMessageData();
   

    // Start the timer when the widget is initialized
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  List<String> getSaintsForToday() {
    List<String> todaySaints = [];
    String todayDate =
        DateTime.now().toString().substring(5, 10); // MM-DD format

    for (var saint in saintList) {
      // Check if celebrationDate is not null and has the expected length
      if (saint['celebrationDate'] != null &&
          saint['celebrationDate'].length >= 10) {
        String celebrationDate = saint['celebrationDate'];
        if (celebrationDate.substring(5, 10) == todayDate) {
          todaySaints.add(saint['name']);
        }
      } else {
        // Handle the case where celebrationDate is invalid
        print('Invalid celebrationDate for saint: ${saint['name']}');
      }
    }
    return todaySaints;
  }

  String formatSaintNames(List<String> saints) {
    if (saints.isEmpty) return '';

    if (saints.length == 1) {
      return saints[0];
    } else if (saints.length == 2) {
      return '${saints[0]} & ${saints[1]}';
    } else {
      String allButLast = saints.sublist(0, saints.length - 1).join(', ');
      String last = saints.last;
      return '$allButLast & $last';
    }
  }

  List<dynamic> getRandomSaints(int count) {
    if (saintList.length <= count) {
      return List.from(saintList); // Return all saints if less than count
    }

    final random = Random();
    final selectedSaints = <dynamic>{}; // Use a Set to avoid duplicates

    while (selectedSaints.length < count) {
      int randomIndex = random.nextInt(saintList.length);
      selectedSaints.add(saintList[randomIndex]);
    }

    return selectedSaints.toList(); // Convert Set back to List
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    final randomSaints = getRandomSaints(10); 

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
            : _error.isNotEmpty && massList.isNotEmpty
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
                              saintName: formatSaintNames(getSaintsForToday()),
                              celebrationDate: formattedDate,
                              imageUrl: saintList[0]['imageUrl'],
                              onReadNow: () {
                                List<String> todaySaints = getSaintsForToday();

                                if (todaySaints.length > 1) {
                                  // Show a dialog with the list of saints
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Select a Saint"),
                                        content: SizedBox(
                                          width: double
                                              .maxFinite, // Make the dialog wide enough
                                          child: ListView.builder(
                                            itemCount: todaySaints.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(todaySaints[index]),
                                                onTap: () {
                                                  // Find the selected saint's details
                                                  var selectedSaint =
                                                      saintList.firstWhere(
                                                    (s) =>
                                                        s['name'] ==
                                                        todaySaints[index],
                                                  );
                                                  print(
                                                      "Selected Saint: ${selectedSaint['name']}");

                                                  // Navigate to the SaintDetailPage with the selected saint's details
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SaintDetailPage(
                                                        saintName:
                                                            selectedSaint[
                                                                'name'],
                                                        saintImage:
                                                            selectedSaint[
                                                                'imageUrl'],
                                                        saintStory:
                                                            selectedSaint[
                                                                'story'],
                                                        videoUrl: selectedSaint[
                                                            'videoUrl'],
                                                      ),
                                                    ),
                                                  );

                                                  // Close the dialog
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (todaySaints.isNotEmpty) {
                                  // If there's only one saint, navigate directly to the detail page
                                  var firstSaint = saintList.firstWhere(
                                      (s) => s['name'] == todaySaints[0]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaintDetailPage(
                                        saintName: firstSaint['name'],
                                        saintImage: firstSaint['imageUrl'],
                                        saintStory: firstSaint['story'],
                                        videoUrl: firstSaint['videoUrl'],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
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
                              height: 5,
                            ),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                itemCount: randomSaints.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final saint = randomSaints[index];
                                  DateTime parseDate = DateTime.parse(saint['celebrationDate']);
                                  String saintDate = DateFormat('MMMM d')
                                      .format(parseDate);
                                  return Recommended(
                                      saintName: saint['name'],
                                      celebrationDate: saintDate,
                                      imageUrl: saint['imageUrl'],
                                      onReadNow: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SaintDetailPage(
                                                    saintName: saint['name'],
                                                    saintImage:
                                                        saint['imageUrl'],
                                                    saintStory: saint['story'],
                                                    videoUrl:
                                                        saint['videoUrl']),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Daily Mass',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (massList.isNotEmpty)
                              DailyMassWidget(
                                imageUrl: massList[0]['imageUrl'] ??
                                    '', // Provide a fallback if null
                                videoUrl: massList[0]['videoUrl'] ??
                                    '', // Provide a fallback if null
                              )
                            else
                              const Text(
                                  'No Daily Mass Data Available'), // Handle empty massList case
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Daily Message',
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: dailymessageList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final message = dailymessageList[index];
                                  if (dailymessageList.isNotEmpty) {
                                    return Message(
                                        imageUrl: message['imageUrl'],
                                        videoUrl: message['videoUrl'],
                                        title: message['title']);
                                  } else {
                                    return const Text(
                                        'No Daily Message Data Available');
                                  }
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
