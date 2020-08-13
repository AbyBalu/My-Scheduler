import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myscheduler/config/config.dart';

class EmailPassSignupScreen extends StatefulWidget {
  EmailPassSignupScreen({Key key}) : super(key: key);

  @override
  _EmailPassSignupScreenState createState() => _EmailPassSignupScreenState();
}

class _EmailPassSignupScreenState extends State<EmailPassSignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Email Sign Up"),
       ),
       body: SingleChildScrollView(
         child: Container(
           width: MediaQuery.of(context).size.width,
           child: Column(
             children: <Widget>[
               Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 40),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: "Write email here",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Write password here",
                    ),
                    obscureText: true,
                  )),
              InkWell(
                  onTap: () {
                    _signup();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor]),
                        borderRadius: BorderRadius.circular(8)),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Center(
                        child: Text("Sign Up with Email",
                            style: TextStyle(color: Colors.white))),
                  )),
             ],
            )
         )
       ),
    );
  }

  void _signup(){

    final String emailTxt = _emailController.text.trim();
    final String passwordTxt = _passwordController.text;

    if(emailTxt.isNotEmpty && passwordTxt.isNotEmpty){
      
      _auth.createUserWithEmailAndPassword(
        email: emailTxt, 
        password: passwordTxt
        )
        .then((user) {

          _db.collection("users").document(user.user.uid).setData({
            "email": emailTxt,
            "lastseen": DateTime.now(),
            "signin_method": user.user.providerId
          });
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Done"),
                content: Text("Sign Up completed. Now please Sign In"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      _emailController.text = "";
                      _passwordController.text = "";
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
        })
        .catchError((e){
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text("Error"),
                content: Text("${e.message}"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
        });
    }
    else{
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Error"),
              content: Text("Please provide email and password."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    _emailController.text = "";
                    _passwordController.text = "";
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          });
    }
  }
}