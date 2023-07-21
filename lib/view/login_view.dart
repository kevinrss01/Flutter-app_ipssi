import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_helper.dart';
import '../globale.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              TextField(
                controller: mail,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email'
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe'
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style : ElevatedButton.styleFrom(
                      backgroundColor : Colors.blueAccent,
                      shape : const StadiumBorder()
                  ),

                  onPressed : (){
                    FirestoreHelper().connect(mail.text, password.text).then((value)
                    {
                      setState(() {
                        userData = value;
                      });
                      Navigator.push(context,MaterialPageRoute(
                          builder : (context){
                            return const MyDashBoardView();
                          }
                      ));
                    }).catchError((onError){
                      if (kDebugMode) {
                        print(onError);
                      }
                    });
                  },

                  child : const Text("Connexion")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
