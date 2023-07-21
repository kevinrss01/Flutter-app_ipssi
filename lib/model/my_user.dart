import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipssisqy2023/globale.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math';


class MyUser {
  late String id;
  late String mail;
  late String nom;
  late String prenom;
  String? pseudo;
  DateTime? birthday;
  String? avatar;
  String? birthdayFormatted;
  String? genre;
  List? favoris;
  String? phoneNumber;
  String get fullName => "$prenom $nom";
  Map<String, dynamic> ?messages;

  //
  MyUser.empty() {
    id = "";
    mail = "";
    nom = "";
    prenom = "";
    messages = {};
  }

  MyUser(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    mail = map["EMAIL"];
    nom = map["NOM"];
    prenom = map["PRENOM"];
    String? provisoirePseudo = map["PSEUDO"];

    if (provisoirePseudo == null) {
      pseudo = "";
    } else {
      pseudo = provisoirePseudo;
    }


    Timestamp? provisoireBirthday = map["BIRTHDAY"];
    if (provisoireBirthday != null) {
      birthday = provisoireBirthday.toDate();

      WidgetsFlutterBinding.ensureInitialized();
      initializeDateFormatting('fr_FR', null).then((_) {
        var formatter = DateFormat('d MMMM yyyy', 'fr_FR');
        birthdayFormatted = formatter.format(birthday!);
      });
    } else {
      birthday = DateTime.now(); // or any default date you prefer

      WidgetsFlutterBinding.ensureInitialized();
      initializeDateFormatting('fr_FR', null).then((_) {
        var formatter = DateFormat('d MMMM yyyy', 'fr_FR');
        birthdayFormatted = formatter.format(birthday!);
      });
    }

    avatar = map["AVATAR"] ?? defaultImage;
    favoris = map["FAVORIS"] ?? [];
    genre = map["GENRE"] ?? "Genre non spécifié";
    phoneNumber = map["PHONE_NUMBER"] ?? "";
    messages = map["MESSAGES"] ?? {};
  }
}
