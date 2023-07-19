import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:ipssisqy2023/model/my_user.dart';
import 'package:intl/intl.dart';

import '../controller/firestore_helper.dart';

class UserInfo extends StatefulWidget {
  final MyUser user;

  const UserInfo({Key? key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  @override
  Widget build(BuildContext context) {
    var userData = widget.user;
    String imageUrl = userData.avatar!;
    String firstName = userData.prenom;
    String fullName = userData.fullName;
    String email = userData.mail;
    String userId = userData.id;
    String pseudo = userData.pseudo == "" ? "Pas de pseudo" : userData.pseudo!;
    String birthday = userData.birthdayFormatted != null ? userData.birthdayFormatted.toString() : userData.birthday.toString();
    String gender = userData.genre!;
    List? friends = userData.favoris;
    String phone = userData.phoneNumber == "" || userData.phoneNumber == null ? "Aucun numéro spécifié" : userData.phoneNumber!;

    Future<Object> getUser(String uid){
      if(friends == null || friends.isEmpty){
        return Future.value('');
      }
      return FirestoreHelper().getUser(uid).then((value){
        return {
          "fullName": value.fullName,
          "avatar": value.avatar
        }; // Ensure that this value is a String, as this is what will be provided to the builder of FutureBuilder
      });
    }

    int currentIndex = 0;

    showContact(){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return Material(
              color: Colors.transparent,
              child: CupertinoAlertDialog(
              title: Text("Information de contact de $fullName"),
              content: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.mail),
                    title: Text(email, style: const TextStyle(fontSize: 17),),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(phone, style: const TextStyle(fontSize: 17),),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child: const Text("Ok")
                ),
              ],
            ),
            );
          }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Informations de $fullName"),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                  CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                Text(fullName, style: const TextStyle(fontSize: 30),)
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("id : $userId", style: const TextStyle(fontSize: 16, color: Colors.grey),),
                ),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title: Text(email, style: const TextStyle(fontSize: 20),),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(phone, style: const TextStyle(fontSize: 20),),
                ),
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: Text(pseudo, style: const TextStyle(fontSize: 20),),
                ),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: Text(birthday, style: const TextStyle(fontSize: 20),),
                ),
                ListTile(
                  leading: const Icon(Icons.circle),
                  title: Text(gender, style: const TextStyle(fontSize: 20),),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: Text("Tous les amis de $firstName :", style: const TextStyle(fontSize: 20),),
                ),
                Container(
                  child: (friends == null || friends.isEmpty)
                      ? const Center(
                        child: Text("Pas de favoris :(", style: TextStyle(fontSize: 20),),
                  )
                      : Column(
                    children: friends.map((friend) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: getUser(friend.toString()),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Erreur: ${snapshot.error}');
                              } else {
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(snapshot.data['avatar']),
                                    ),
                                    const SizedBox(width: 30),
                                    Text(snapshot.data['fullName'], style: TextStyle(fontSize: 20),),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  )
                  ),
              ],
            )
          )
        ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Contacter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.heart_broken_outlined),
            label: "Supprimer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: "Bloquer"
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          switch (index) {
            case 0:
              setState(() {
                currentIndex = 0;
              });
              showContact();
              break;
            case 1:
              setState(() {
                currentIndex = 1;
              });
              print("Supprimer");
              break;
            case 2:
              setState(() {
                currentIndex = 2;
              });
              print("Bloquer");
              break;
          }
        },
      )
    );
  }
}
