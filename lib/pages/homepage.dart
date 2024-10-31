import 'package:flutter/material.dart';
import 'package:bookofsaints/widgets/saintcardwidget.dart';
import 'package:bookofsaints/widgets/recommendedwidget.dart';
import 'package:bookofsaints/model/apifetchdata.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> saintList = [];
  bool _isLoading = true;
  String _error = '';

  Future<void> loadData() async {
    try {
      final data = await fetchData();
      setState(() {
        saintList = data;
        print(saintList);
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






// return Scaffold(
//       appBar: AppBar(),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : _error.isNotEmpty
//               ? Center(
//                   child: Text(_error),
//                 )
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SaintCard(
//                             saintName: saintList[0]['name'],
//                             celebrationDate: "$day - $month",
//                             imageUrl: saintList[0]['videoUrl'],
//                             onReadNow: () {}),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         const Text(
//                           "Recommended",
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 150,
//                           child: FutureBuilder(
//                             future: fetchData(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               } else if (snapshot.hasError) {
//                                 return Center(
//                                   child: Text('Error: ${snapshot.error}'),
//                                 );
//                               } else if (!snapshot.hasData) {
//                                 return const Text('No Saints Found');
//                               } else {
//                                 final saints = snapshot.data as List<dynamic>;
//                                 return ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: saints
//                                       .length, // Replace with the desired number of items
//                                   itemBuilder: (context, index) {
//                                     final saint = saints[index];
//                                     return Recommended(
//                                         saintName: saint['name'],
//                                         celebrationDate:
//                                             saint['celebrationDate'],
//                                         imageUrl: saint['imageUrl'],
//                                         onReadNow: () {});
//                                   },
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
  
