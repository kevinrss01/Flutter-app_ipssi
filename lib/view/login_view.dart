import 'package:flutter/material.dart';

import '../controller/firestore_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            ElevatedButton(
                style : ElevatedButton.styleFrom(
                    backgroundColor : Colors.blueAccent,
                    shape : const StadiumBorder()
                ),

                onPressed : (){
                  // FirestoreHelper().connect(mail.text, password.text).then((value)
                  // {
                  //   setState(() {
                  //     userData = value;
                  //   });
                  //   Navigator.push(context,MaterialPageRoute(
                  //       builder : (context){
                  //         return const MyDashBoardView();
                  //       }
                  //   ));
                  // }).catchError((onError){
                  //   if (kDebugMode) {
                  //     print(onError);
                  //   }
                  // });
                },

                child : const Text("Connexion")
            ),
          ],
        ),
      ),
    );
  }
}
