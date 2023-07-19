import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/firestore_helper.dart';
import 'package:ipssisqy2023/globale.dart';
import 'package:ipssisqy2023/model/my_user.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().cloudUsers.snapshots(),
      builder: (context, snap){
        List documents = snap.data?.docs ?? [];
        if(documents == [] || documents.isEmpty){
          return const Center(
            child : CircularProgressIndicator()
          );
        } else {
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index){
              MyUser otherUser = MyUser(documents[index]);
              if(userData.id == otherUser.id){
                return Container();
              }
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.blueAccent,
                child: ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(otherUser.avatar ?? defaultImage)
                      )
                    )
                  ),
                  title: Text(otherUser.fullName),
                  subtitle: Text(otherUser.mail),
                  trailing: IconButton(
                    onPressed: (){
                      if(userData.favoris!.contains(otherUser.id)){
                        userData.favoris!.remove(otherUser.id);
                      } else {
                        userData.favoris!.add(otherUser.id);
                      }
                      Map<String, dynamic> map ={
                        "FAVORIS": userData.favoris
                      };
                      FirestoreHelper().updateUser(userData.id, map);
                    },
                    icon: Icon(Icons.favorite, color: (userData.favoris!.contains(otherUser.id)) ? Colors.red : Colors.grey,),
                  )
                ),
              );
            }
          );
        }
      }
    );
  }
}
