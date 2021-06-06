import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pankaj_dice_game/main.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leader board"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child("user").orderByChild("score").onValue,
        builder: (context, snapshot) {
          if (snapshot != null) {
            try {
              Map data = snapshot.data.snapshot.value;
              List<Map> dataList = [];
              data.forEach((key, value) {
                dataList.add(value);
              });

              if (dataList.length > 0) {
                dataList.sort((a, b) => b["score"].compareTo(a["score"]));
              }

              return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: firebaseAuth.currentUser.uid == dataList[index]["user_id"] ? Colors.blue : Colors.white,
                      title: firebaseAuth.currentUser.uid == dataList[index]["user_id"]
                          ? Text("You")
                          : Text(dataList[index]["user_name"]),
                      trailing: Text("Score : " + dataList[index]["score"].toString()),
                      subtitle: Text("attempts: ${10 - dataList[index]["attempt_remaining"]}/10"),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: dataList.length);
            } catch (e) {
              print("exception-->$e");
            }
          }

          return Container();
        },
      ),
    );
  }
}
