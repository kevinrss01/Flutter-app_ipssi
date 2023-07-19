//classe qui va nou aider à la gestion de la base de donnée

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipssisqy2023/model/my_user.dart';

class FirestoreHelper{
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("USERS");

  // Future obligatoire car la fonction retourne quelque chose
  //inscription
  Future <MyUser> register(String email , String password, String nom, String prenom, String pseudo) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);

    String uid = result.user?.uid ?? "";
    Map<String,dynamic> map = {
      "EMAIL":email,
      "NOM": nom,
      "PRENOM":prenom,
      "PSEUDO":pseudo,
    };
    addUser(uid, map);
    return await getUser(uid);
  }

  // Future obligatoire car la fonction retourne quelque chose
  Future <MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser(snapshot);
  }

  addUser(String uid, Map<String,dynamic> data){
    cloudUsers.doc(uid).set(data);

  }

  Future<MyUser>connect(String email, String password) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);

    String uid = result.user?.uid ?? "";

    return await getUser(uid);
  }

  Future<String> stockageData(String ref, String uid, String nameData, Uint8List bytesData) async {
    TaskSnapshot snapshot =  await storage.ref("$ref/$uid/$nameData").putData(bytesData);
    String urlData = await snapshot.ref.getDownloadURL();
    return urlData;

  }

  updateUser(String uid, Map<String,dynamic> data){
    cloudUsers.doc(uid).update(data);
  }

}