import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/globale.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Mydrawer extends StatefulWidget {
  const Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  bool isInputDisplayed = false;
  TextEditingController pseudo = TextEditingController();
  String? nameImage;
  Uint8List? bytesImage;

  popImage(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: const Text("Souhaitez-vous enregistrer cette image ?"),
            content: Image.memory(bytesImage!),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: const Text("Annulation")
              ),
              TextButton(
                  onPressed: (){
                    //effectuer l'enregsitrement
                    //stokcer notre image
                    FirestoreHelper().stockageData("images", userData.id, nameImage!, bytesImage!).then((value){
                      setState(() {
                        userData.avatar = value;
                      });

                      Map<String,dynamic> map = {
                        "AVATAR": value
                      };
                      //mettre à jour les informations de l'utilisateur
                      FirestoreHelper().updateUser(userData.id, map);

                      Navigator.pop(context);
                    });
                  }, child: const Text("Enregistrement")
              ),
            ],
          );
        }
    );
  }

  //Functions
  accessPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null){
      nameImage = result.files.first.name;
      bytesImage = result.files.first.bytes;
      popImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  accessPhoto();
                },
                child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userData.avatar ?? defaultImage),
                ),
              ),
              const Divider(
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(userData.prenom, style: const TextStyle(fontSize: 20),),
              ),
              ListTile(
                leading: const Icon(Icons.mail),
                title: Text(userData.mail, style: const TextStyle(fontSize: 20),),
              ),
              const Divider(
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: isInputDisplayed ?
                  TextField(
                    controller: pseudo,
                    decoration: InputDecoration(hintText: userData.pseudo ?? ""),
                    style: const TextStyle(fontSize: 20, color: Colors.black)
                  ) :
                  Text(userData.pseudo == "" ? "Pas de pseudo" : userData.pseudo!,
                    style: const TextStyle(fontSize: 20, color: Colors.black),),
                trailing: IconButton(
                  icon: !isInputDisplayed ? const Icon(Icons.edit) : const Icon(Icons.check),
                  onPressed: (){

                    if(isInputDisplayed) {
                      if(pseudo.text != "" && pseudo.text != userData.pseudo) {
                        Map<String, dynamic> map = {
                          "PSEUDO": pseudo.text,
                        };
                        setState(() {
                          userData.pseudo = pseudo.text;
                        });
                        FirestoreHelper().updateUser(userData.id, map);

                      }
                    }

                    setState(() {
                      isInputDisplayed = !isInputDisplayed;
                    });
                  },
                ),
              ),
            ],
          ),

        )
    );
  }
}
