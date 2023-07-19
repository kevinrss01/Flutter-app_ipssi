import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/my_permission.dart';
import 'package:ipssisqy2023/view/register_view.dart';
import 'package:ipssisqy2023/view/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyPermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0; // Index de l'élément actuellement sélectionné dans la bottom navigation bar

  final List<Widget> _pages = [
    const MyRegisterView(),
    const LoginView(),
    // Ajoutez les autres écrans que vous souhaitez afficher dans la navigation ici
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inscription',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Connexion',
            ),
            // Ajoutez les autres éléments de navigation ici
          ],
        ),
      ),
    );
  }
}
