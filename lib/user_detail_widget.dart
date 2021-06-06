import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pankaj_dice_game/constant.dart';
import 'package:pankaj_dice_game/main.dart';

class UserDetailWidget extends StatefulWidget {
  @override
  _UserDetailWidgetState createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  String name = "";
  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$name",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${firebaseAuth.currentUser.email}",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void getName() async {
    name = await Constant.getStringPreference(Constant.USER_NAME);
    setState(() {});
  }
}
