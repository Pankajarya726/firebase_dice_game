import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pankaj_dice_game/constant.dart';
import 'package:pankaj_dice_game/dialog.dart';
import 'package:pankaj_dice_game/validator.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    edtPassword.dispose();
    edtUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var editTextUsername = TextFormField(
      controller: edtUsername,
      validator: (value) => Validator.emailValidator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: "Email", labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
    );
    var editTextPassword = TextFormField(
      controller: edtPassword,
      obscureText: true,
      obscuringCharacter: "*",
      decoration:
          InputDecoration(hintText: "Password", labelText: "Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
    );
    var loginButton = MaterialButton(
      onPressed: () => authUser(),
      child: Text(
        "Login",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blueAccent,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              editTextUsername,
              SizedBox(
                height: 20,
              ),
              editTextPassword,
              SizedBox(
                height: 20,
              ),
              loading ? CircularProgressIndicator() : loginButton,
              SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                    text: "Register",
                    style: TextStyle(color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      })
              ]))
            ],
          ),
        ),
      ),
    );
  }

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

  void _register() {
    Navigator.pushNamed(context, "/register");
  }
}
