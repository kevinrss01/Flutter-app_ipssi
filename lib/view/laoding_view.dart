import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoadingPage extends StatefulWidget {
  const MyLoadingPage({super.key});

  @override
  State<MyLoadingPage> createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading"),
      ),
      body: PageView(
        children: [
          Center(
            child: Lottie.asset('assets/fight.json'),
          ),
          Center(
            child: Lottie.asset('assets/sablier.json'),
          ),
          Center(
            child: Lottie.asset('assets/pacman.json'),
          ),
      ],
      ),
    );
  }
}
