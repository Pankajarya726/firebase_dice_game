import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pankaj_dice_game/constant.dart';
import 'package:pankaj_dice_game/dialog.dart';
import 'package:pankaj_dice_game/validator.dart';

import 'main.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final edtName = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var editTextName = TextFormField(
      controller: edtName,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your name',
        labelText: 'Name',
      ),
    );
    var editTextEmail = TextFormField(
      controller: edtEmail,
      validator: (value) => Validator.emailValidator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your email',
        labelText: 'Email',
      ),
    );

    var editTextPassword = TextFormField(
      controller: edtPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your password',
        labelText: 'Password',
      ),
    );
    var registerButton = MaterialButton(
      onPressed: () => register(context),
      child: Text(
        "Register",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blueAccent,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            editTextName,
            SizedBox(
              height: 15,
            ),
            editTextEmail,
            SizedBox(
              height: 15,
            ),
            editTextPassword,
            SizedBox(
              height: 15,
            ),
            loading ? CircularProgressIndicator() : registerButton,
            SizedBox(
              height: 15,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                  text: "Login",
                  style: TextStyle(color: Colors.blueAccent),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
                    })
            ]))
          ],
        ),
      ),
    );
  }

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
}
