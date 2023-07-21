import 'package:flutter/material.dart';
import 'package:ipssisqy2023/controller/conversation.dart';
import 'package:ipssisqy2023/globale.dart';

import '../model/user_data.dart';

class MyMessages extends StatefulWidget {
  MyMessages({Key? key}) : super(key: key);

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tous mes messages"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 560,
              child: ListView.builder(
                  itemCount: userData.messages?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Card(
                        color: Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Conversation ${index + 1}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),

                      ),
                      onTap: () {
                        //
                      }
                    );
                  }),
            ),
            // Autres widgets ici
          ],
        ),
      ),
    );
  }
}
