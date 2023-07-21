import 'package:flutter/material.dart';
import 'package:ipssisqy2023/model/user_data.dart';
import 'package:uuid/uuid.dart';

import '../globale.dart';
import 'firestore_helper.dart';

class Conversation extends StatefulWidget {
  final UserData otherUser;
  final String otherUserId;

  const Conversation(
      {super.key, required this.otherUser, required this.otherUserId});

  @override
  State<Conversation> createState() => _ConversationState();
}

createNewConversations(otherUserId) {
  Map<String, dynamic> conversationOfOtherUser = {
    "MESSAGES": {userData.id: []}
  };

  Map<String, dynamic> conversationOfActualUser = {
    "MESSAGES": {otherUserId: []}
  };

  //mettre à jour les informations de l'utilisateur
  FirestoreHelper().updateUser(userData.id, conversationOfActualUser);
  FirestoreHelper().updateUser(otherUserId, conversationOfOtherUser);
}

updateConversationInFirestore(
    List<AllMessagesByUser> conversation, String otherUserId) {
  // Convert each AllMessagesByUser object to a Map
  List<Map<String, dynamic>> conversationData = conversation.map((message) {
    return {
      'id': message.id,
      'message': message.message,
      'sender': message.sender,
      'receiver': message.receiver,
      'date': message.date,
    };
  }).toList(); // convert the iterable to a list

  Map<String, dynamic> conversationOfOtherUser = {
    "MESSAGES": {userData.id: conversationData}
  };

  Map<String, dynamic> conversationOfActualUser = {
    "MESSAGES": {otherUserId: conversationData}
  };

  //mettre à jour les informations de l'utilisateur
  FirestoreHelper().updateUser(userData.id, conversationOfActualUser);
  FirestoreHelper().updateUser(otherUserId, conversationOfOtherUser);
}

class _ConversationState extends State<Conversation> {
  late UserData otherUserData;
  String otherUserId = "";
  List<AllMessagesByUser> conversation = [];

  updateConversationDisplayed(otherUserData) {
    setState(() {
      conversation =
          otherUserData.MESSAGES.data[userData.id].cast<AllMessagesByUser>();
    });
  }

  @override
  void initState() {
    super.initState();
    otherUserData = widget.otherUser;
    otherUserId = widget.otherUserId;

    if (otherUserData.MESSAGES.data[userData.id] == null &&
        userData.messages?[otherUserId] == null) {
      createNewConversations(otherUserId);

      userData.messages?[otherUserId] = [];
      otherUserData.MESSAGES.data[userData.id] = [];
    } else {
      updateConversationDisplayed(otherUserData);
    }
  }

  Widget build(BuildContext context) {
    TextEditingController message = TextEditingController();

    sendMessage(messageContent) {
      AllMessagesByUser newMessage = AllMessagesByUser(
          id: Uuid().v4(),
          message: messageContent,
          sender: userData.id,
          receiver: otherUserId,
          date: DateTime.now().toString());

      setState(() {
        userData.messages?[otherUserId].add(newMessage);
        conversation.add(newMessage);
      });

      updateConversationInFirestore(conversation, otherUserId);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${otherUserData.PRENOM} ${otherUserData.NOM} (${otherUserData.PSEUDO})"),
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 560,
              child: ListView.builder(
                  itemCount: conversation.length,
                  itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 0.7,
                      alignment: conversation[index].sender == userData.id
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: conversation[index].sender == userData.id
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(conversation[index].message),
                          subtitle:
                              Text(conversation[index].date.substring(11, 16)),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: message,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ecrivez votre message',
                ),
              ),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (message.text.isNotEmpty) {
              sendMessage(message.text);
            }
          },
          child: const Icon(Icons.send),
        ));
  }
}
