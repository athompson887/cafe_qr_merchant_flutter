import 'package:cafe_qr_merchant/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafe_qr_merchant/components/rounded_button.dart';
import 'package:cafe_qr_merchant/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  TextEditingController _emailTextController = new TextEditingController(text:"a.thompson887@btinternet.com");
  TextEditingController _passwordTextController = new TextEditingController(text:"C0ttagesalt?");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Lottie.asset('images/coffeecup.json'),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordTextController,
                obscureText: false,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    var _user = await _auth.currentUser;
                    if(_user == null) {
                      _user = (await _auth.signInWithEmailAndPassword(
                          email: email, password: password)) as User;
                    }
                    setState(() {
                      showSpinner = false;
                      Navigator.pushNamed(context, HomeScreen.id);
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
