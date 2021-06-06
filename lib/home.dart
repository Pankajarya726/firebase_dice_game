import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_version/get_version.dart';
import 'package:pankaj_dice_game/constant.dart';
import 'package:pankaj_dice_game/main.dart';
import 'package:pankaj_dice_game/user_detail_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String projectVersion = "";
  int currentImage = 6;
  var imageArray = ['images/one.png', 'images/two.png', 'images/three.png', 'images/four.png', 'images/five.png', 'images/six.png'];
  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 120,
              child: UserDetailWidget(),
            ),
            ListTile(
              title: Text("Leader board"),
              leading: Icon(Icons.leaderboard),
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  "/leader_board",
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () async {
                await firebaseAuth.signOut();
                await Constant.clearSharedPreference(context);

                Navigator.pushNamedAndRemoveUntil(context, "/login", ModalRoute.withName("/"));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("user")
              .orderByChild("user_id")
              .equalTo(firebaseAuth.currentUser.uid)
              .onValue,
          builder: (context, snap) {
            int remainingChance = 0;
            int totalScore = 0;
            String userid = "";

            if (snap != null) {
              try {
                Map data = snap.data.snapshot.value;

                data.forEach((key, value) {
                  userid = key;
                  Map user = value;

                  remainingChance = user["attempt_remaining"];
                  totalScore = user["score"];
                });

                print("data---->");
                print(data);
              } catch (e) {
                print("exception---->$e");
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Attempts : ${10 - remainingChance}/10",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Your score : $totalScore",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imageArray[currentImage - 1],
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                    onPressed: () {
                      if (remainingChance > 0) {
                        Random random = new Random();
                        int randomNumber = random.nextInt(6) + 1;
                        currentImage = randomNumber;
                        print(randomNumber);

                        FirebaseDatabase.instance.reference().child("user").child(userid).update({
                          "attempt_remaining": remainingChance - 1,
                          "score": totalScore + randomNumber,
                        });
                      } else {
                        Fluttertoast.showToast(msg: "You don't have any attempts remaining");
                      }
                    },
                    color: remainingChance > 0 ? Colors.blue : Colors.blueGrey,
                    child: Text(
                      "Roll",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Text("Current app version : $projectVersion"),
      ),
    );
  }

  getVersion() async {
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }
    print(projectVersion);
    setState(() {});
  }
}
