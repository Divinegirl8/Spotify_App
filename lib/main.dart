import 'package:flutter/material.dart';
import 'homepage.dart';
import 'screens/music_player.dart';

void main() {
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      // home:  Homepage(),
       home:  const MusicPlayer(),
      
    );
  }
}
