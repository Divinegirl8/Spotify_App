import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget{
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'Spotify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(background: Colors.grey.shade100)
      ),
    );
  }
}