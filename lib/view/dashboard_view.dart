import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/my_favorites.dart';
import 'package:ipssisqy2023/view/my_drawer.dart';

import '../controller/all_users.dart';
import '../controller/my_favorites.dart';

class MyDashBoardView extends StatefulWidget {
  const MyDashBoardView({super.key});

  @override
  State<MyDashBoardView> createState() => _MyDashBoardViewState();
}

class _MyDashBoardViewState extends State<MyDashBoardView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
      SafeArea(
        top: false,
        bottom: false,
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: Colors.blueAccent,
          child: const Mydrawer()
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        //elevation: 0,
      ),
      body: bodyPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: "Utilisateurs"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Mes amis"
          ),
        ],
      )
    );
  }

  bodyPage() {
    switch(currentIndex){
      case 0 : return const AllUsers();
      case 1 : return const MyFavorites();
      default: return const Text("Problème d'affichage");
    }
  }
}
