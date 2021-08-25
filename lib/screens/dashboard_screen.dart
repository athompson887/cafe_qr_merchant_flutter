import 'package:async/async.dart';
import 'package:cafe_qr_merchant/data/VenueModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DynamicTheme.dart';
import '../ThemeData.dart';

final _firestore = FirebaseFirestore.instance;
FirebaseAuth loggedInUser;

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    final _auth = FirebaseAuth.instance;
    return new MyHomeState(_auth.currentUser.uid);
  }
}

class MyHomeState extends State<DashboardScreen> {
  final String documentId;
  MyHomeState(this.documentId);

  List<ThemeItem> _themeItems = ThemeItem.getThemeItems();
  List<DropdownMenuItem<ThemeItem>> _dropDownMenuItems;
  List<Venue> all = new List.empty(growable: true);
  ThemeItem _selectedItem;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user as FirebaseAuth;
      }
    } catch (e) {
      print(e);
    }
  }

  List<DropdownMenuItem<ThemeItem>> buildDropdownMenuItems() {
    List<DropdownMenuItem<ThemeItem>> items = List();
    for (ThemeItem themeItem in _themeItems) {
      items
          .add(DropdownMenuItem(value: themeItem, child: Text(themeItem.name)));
    }
    return items;
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(this._selectedItem.themeData);
  }

  setSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dynTheme', _selectedItem.slug);
  }

  onChangeDropdownItem(ThemeItem selectedItem) {
    setState(() {
      this._selectedItem = selectedItem;
    });
    changeColor();
    setSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
            title: Text("Dashboard"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
            DropdownButton(
              icon: Icon(Icons.palette, color: Colors.white),
              items: _dropDownMenuItems,
              onChanged: onChangeDropdownItem,
              underline: SizedBox(),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          leading: null,
         backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            VenueListView(),
          ],
        ),
      ),
    );
  }
  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
          );
        });
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }
}


class VenueListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('venues').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final venues = snapshot.data.docs;
        List<ListTile> list = [];
        for (var message in venues) {
          final item = ListTile(
            title: Text(message.get('name')),
            subtitle: Text(message.get('location')),
            leading: Image.network(message.get('imageUrl')),
            selectedTileColor:Colors.green[400],
            onTap: () {
            },
          );
          list.add(item);
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: list,
          ),
        );
      },
    );
  }
}