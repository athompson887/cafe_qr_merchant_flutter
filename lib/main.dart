import 'package:cafe_qr_merchant/screens/chat_screen.dart';
import 'package:cafe_qr_merchant/screens/login_screen.dart';
import 'package:cafe_qr_merchant/screens/registration_screen.dart';
import 'package:cafe_qr_merchant/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'DynamicTheme.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var  user =  FirebaseAuth.instance.currentUser;
  print(user);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            initialRoute: WelcomeScreen.id,
            routes: {
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              HomeScreen.id: (context) => HomeScreen(),
            },
          );
        });
  }
}
