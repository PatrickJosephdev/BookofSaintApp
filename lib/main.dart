import 'package:flutter/material.dart';
import 'package:myapp/pages/pagecontrol.dart';
import 'package:myapp/themes/themeprovider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeDataStyle,
      home: const PageControl(),
    );
  }
}
