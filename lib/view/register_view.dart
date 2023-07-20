import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/animation_controller.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/view/dashboard_view.dart';
import 'package:ipssisqy2023/view/my_background.dart';
import 'package:select_form_field/select_form_field.dart';

import '../globale.dart';

class MyRegisterView extends StatefulWidget {
  const MyRegisterView({super.key});

  @override
  State<MyRegisterView> createState() => _MyRegisterViewState();
}

class _MyRegisterViewState extends State<MyRegisterView> {
  //variable
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController pseudo = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'boxValue',
      'label': 'Homme',
      'icon': const Icon(Icons.man),
    },
    {
      'value': 'circleValue',
      'label': 'Femme',
      'icon': const Icon(Icons.woman),
    },
    {
      'value': 'starValue',
      'label': 'Hélicoptère de combat',
      'icon': const Icon(Icons.airplanemode_on),
    },
  ];

  //Functions
  myPopUpError(String message){
    showDialog(
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: const Text("Erreur"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("OK")
                )
              ],
            );
          }
          else {
            return AlertDialog(
              title: const Text("Erreur"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("OK")
                )
              ],
            );
          }
        }
    );
  }

  List<String> genderOptions = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Flutter APP"),
            backgroundColor: Colors.blueAccent,
            centerTitle : true
        ),
        body:  Stack(
          children: [
            const MyBackground(),
            SingleChildScrollView(
                child : Padding(
                    padding : const EdgeInsets.all(10),
                    child : Center(
                        child :   Column(
                            mainAxisAlignment : MainAxisAlignment.center,
                            children : [
                              //image
                              Image.asset(
                                'assets/Logo-6-[remix]-[remix].gif',
                                width: 500,
                                height: 190,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height : 15),

                              //First Name
                              TextField(
                                    controller: prenom,
                                    decoration : InputDecoration(
                                        hintText: "Entrer votre prénom",
                                        prefixIcon : const Icon(Icons.person),
                                        border : OutlineInputBorder(
                                          borderRadius : BorderRadius.circular(15),

                                        )

                                    )

                                ),
                              const SizedBox(height : 15),

                                //Name
                                TextField(
                                    controller: nom,
                                    decoration : InputDecoration(
                                        hintText: "Entrer votre nom",
                                        prefixIcon : const Icon(Icons.person),
                                        border : OutlineInputBorder(
                                          borderRadius : BorderRadius.circular(15),
                                        )
                                    )

                                ),
                              const SizedBox(height : 15),

                              //pseudo
                              TextField(
                                controller: pseudo,
                                decoration: InputDecoration(
                                  hintText: "Entrer votre pseudo",
                                  prefixIcon: const Icon(Icons.text_fields),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),

                              const SizedBox(height : 15),

                            //Gender
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SelectFormField(
                                controller: gender,
                                type: SelectFormFieldType.dropdown, // or can be dialog
                                icon: const Icon(Icons.circle),
                                labelText: 'Genre',
                                items: _items,
                                onChanged: (val) => print(val),
                                onSaved: (val) => print(val),
                              ),
                            ),

                              const SizedBox(height : 15),

                              //Email
                              TextField(
                                  controller: mail,
                                    decoration : InputDecoration(
                                        hintText: "Entrer votre adresse mail",
                                        prefixIcon : const Icon(Icons.mail),
                                        border : OutlineInputBorder(
                                          borderRadius : BorderRadius.circular(15),

                                        )

                                    )

                                ),

                              const SizedBox(height : 15),

                              TextField(
                                  controller: phoneNumber,
                                    decoration : InputDecoration(
                                        hintText: "Entrer votre numéro de téléhphone",
                                        prefixIcon : const Icon(Icons.phone),
                                        border : OutlineInputBorder(
                                          borderRadius : BorderRadius.circular(15),

                                        )

                                    )

                                ),

                              const SizedBox(height : 15),

                              //Password
                              TextField(
                                  controller : password,
                                  obscureText : true,
                                  decoration : InputDecoration(
                                      hintText: "Entrer votre mot de passe",
                                      prefixIcon : const Icon(Icons.lock),
                                      border : OutlineInputBorder(
                                        borderRadius : BorderRadius.circular(15),
                                      )
                                  ),
                                ),

                              const SizedBox(height : 15),

                              MyAnimationController(
                                  delay: 0,
                                  child: ElevatedButton(
                                    style : ElevatedButton.styleFrom(
                                        backgroundColor : Colors.blueAccent,
                                        shape : const StadiumBorder()
                                    ),
                                    onPressed: (){
                                      if(nom.text != "" && prenom.text != "" && pseudo.text != "" && gender.text != "" && phoneNumber.text != "" && mail.text != "" && password.text != ""){
                                        FirestoreHelper().register(mail.text, password.text,nom.text,prenom.text, pseudo.text, gender.text, phoneNumber.text).then((value){
                                          setState(() {
                                            userData = value;
                                          });
                                          Navigator.push(context,MaterialPageRoute(
                                              builder : (context){
                                                return const MyDashBoardView();
                                              }
                                          ));
                                        }).catchError((onError) {
                                          if (kDebugMode) {
                                            print(onError);
                                          }
                                          if(onError is FirebaseAuthException){
                                            String? errorMessage = onError.message;
                                            if(errorMessage != null && errorMessage.contains('The email address is badly formatted')){
                                              myPopUpError('Veuillez fournir une adresse mail valide');
                                            }
                                            if(errorMessage != null && errorMessage.contains('The email address is already in use')){
                                              myPopUpError('Cette adresse mail est déjà utilisée');
                                            }
                                            if(errorMessage != null && errorMessage.contains('Password should be at least 6 characters')){
                                              myPopUpError('Le mot de passe doit contenir au moins 6 caractères');
                                            }
                                          }

                                        });
                                      } else {
                                        myPopUpError('Veuillez remplir tous les champs');
                                      }

                                    },
                                    child: const Text("Inscription"),
                                  )
                              )

                              //bouton
                            ]
                        )
                    )
                )
            ),
          ],
        )
    );
  }
}
