import 'package:cafe_qr_merchant/data/MenuModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DynamicTheme.dart';

final _firestore = FirebaseFirestore.instance;
FirebaseAuth loggedInUser;

class MenuItemsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    final _auth = FirebaseAuth.instance;
    return new MyHomeState(_auth.currentUser.uid);
  }
}

class MyHomeState extends State<MenuItemsScreen> {
  final String documentId;
  MyHomeState(this.documentId);

  List<Menu> all = new List.empty(growable: true);
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Items"),
        actions: <Widget>[
          SizedBox(
            width: 10,
          ),
        ],
        leading: null,
        backgroundColor:  DynamicTheme.of(context).data.primaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MenuListView(),
          ],
        ),
      ),
    );
  }
}


class MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('menu_item').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final menus = snapshot.data.docs;
        List<ListTile> list = [];
        for (var message in menus) {
          final item = ListTile(
            title: Text(message.get('name')),
            subtitle: Text(message.get('description')),
            leading: Image.network(message.get('imageUrl')),
            selectedTileColor:Colors.green[400],
            onTap: () {
            },
          );
          list.add(item);
        }
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide()),
            ),
          child:  ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: list,
          ),
        )
        );
      },
    );
  }
}