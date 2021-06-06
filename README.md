# Flutter Roll a dice with Firebase.
The application is a game, where the Player can press a button to "Roll a dice", and get a Random
result anywhere between 1 and 6, the Player gets 10 chances to play, and
every time the result of the dice roll should get added to the Player's score.
After 10 attempts the player's results should be logged into the leaderboard. 


A simple usage of FirebaseAuth to login and register users and save detail in firebas realtime database

add firebase_auth, firebase_database package to your pubspec.yaml file

This code is going to validate user input and register the user in using the _email and _password that were saved in firebase realtime database.

register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (edtName.text.isEmpty) {
      AppDialog.validationDialog(context, "Name required!");
    } else if (edtEmail.text.isEmpty) {
      AppDialog.validationDialog(context, "Email required!");
    } else if (edtPassword.text.isEmpty) {
      AppDialog.validationDialog(context, "Password required!");
    } else {
      print("login");
      // Navigator.pushNamed(context, "/home");
      setState(() {
        loading = true;
      });

      try {
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child('user');
        var authResult =
            await firebaseAuth.createUserWithEmailAndPassword(email: edtEmail.text.trim(), password: edtPassword.text.trim());

        if (authResult != null) {
          await userRef.push().set({
            "user_id": authResult.user.uid,
            "user_name": edtName.text.trim(),
            "user_email": edtEmail.text.trim(),
            "user_password": edtPassword.text.trim(),
            "attempt_remaining": 10,
            "score": 0,
          }).whenComplete(() {
            Constant.setBooleanPreference(Constant.IS_LOGIN, true);
            Constant.setStringPreference(Constant.USER_ID, authResult.user.uid);
            Constant.setStringPreference(
              Constant.USER_NAME,
              edtName.text.trim(),
            );
            Constant.setStringPreference(Constant.USER_EMAIL, edtEmail.text.trim());

            Fluttertoast.showToast(msg: "Registration success");
            Navigator.pushNamed(context, "/home");
          });
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          Fluttertoast.showToast(msg: "${e.message}");
        } else {
          Fluttertoast.showToast(msg: "${e.message}");
        }
        setState(() {
          loading = false;
        });
      }
    }
  }
  
  
  After successfully register.
  Here is the code for login using email and password
  
  void authUser() async {
    FocusScope.of(context).unfocus();
    if (edtUsername.text.isEmpty) {
      AppDialog.validationDialog(context, "Username required!");
    } else if (edtPassword.text.isEmpty) {
      AppDialog.validationDialog(context, "Password required!");
    } else {
      print("login");
      setState(() {
        loading = true;
      });
      try {
        var authResult =
            await firebaseAuth.signInWithEmailAndPassword(email: edtUsername.text.trim(), password: edtPassword.text.trim());

        if (authResult != null) {
          DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("user").orderByChild(authResult.user.uid).once();

          if (snapshot.value != null) {
            Map data = snapshot.value;

            data.forEach((key, value) async {
              Map userData = value;
              await Constant.setBooleanPreference(Constant.IS_LOGIN, true);
              await Constant.setStringPreference(Constant.USER_ID, authResult.user.uid);
              await Constant.setStringPreference(Constant.USER_NAME, userData["user_name"]);
              await Constant.setStringPreference(Constant.USER_EMAIL, authResult.user.email);
            });
          }

          Navigator.pushNamed(context, "/home");
        } else {
          Fluttertoast.showToast(msg: "Invalid Credential!");
        }
        setState(() {
          loading = false;
        });
      } catch (exception) {
        setState(() {
          loading = false;
        });
        if (exception is FirebaseAuthException) {
          print(exception.message);
          Fluttertoast.showToast(msg: "${exception.message}");
        } else {
          print(exception.message);
          Fluttertoast.showToast(msg: "${exception.message}");
        }
      }
    }
  }
  
  
  Now Come to the home of app here we going to show the total score, attempts by the user and current app version
  1. add get_version package to your pubspec.yaml file
  here is the code for getting the app version 
  
    getVersion() async {
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }
    print(projectVersion);
    setState(() {});
  }
  
  
  2. showing the no of attempts and total score of user, 
  for the we are using firebase realtime database, i had already add the field for score, remaining_attempts while register user in the database. 
  here is the structure of user info in db 
  ![Screenshot 2021-06-06 at 3 01 15 PM](https://user-images.githubusercontent.com/32188023/120919595-0be93300-c6d8-11eb-92ec-b73568bcc14a.png)
  
  we have 6 images of dice to show the six different face of dice. we will generate a random no between 1-6 on clicking roll button and show the dice image whatever no we get. whenever user press the roll button we reduce the remaining_attempts by 1 in firebase database and add the number in score field in firebase database that we are getting on rolling on dice.
 here is the full code for the above logic

StreamBuilder(
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
        )
        
        
3. showing leaderboard according score of each user
here is the full code for showing leaderboard according to score by user

 StreamBuilder(
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
  

  
  
 
