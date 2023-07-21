import "package:flutter/material.dart";
import "package:ipssisqy2023/controller/firestore_helper.dart";
import "package:ipssisqy2023/globale.dart";

import "../model/my_user.dart";
import "../view/one_user_data.dart";

    class MyFavorites extends StatefulWidget {
      const MyFavorites({super.key});

      @override
      State<MyFavorites> createState() => _MyFavoritesState();
    }

    class _MyFavoritesState extends State<MyFavorites> {
      List<MyUser> favorites = [];

      @override
      void initState() {
        for(String uid in userData.favoris!){
          FirestoreHelper().getUser(uid).then((value){
            setState(() {
              favorites.add(value);
            });

          });
        }

        super.initState();
      }

      @override
      Widget build(BuildContext context) {

        return GridView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemBuilder: (context,index){
              MyUser otherUser = favorites[index];
              return InkWell(
                  onTap: (){
                    print(otherUser.avatar);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserInfo(user: otherUser)));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15)
                ),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(otherUser.avatar ?? defaultImage),
                      ),
                      Text(otherUser.fullName,)
                    ],
                  ),
                ),
              )
              );
            }
        );
      }
    }
