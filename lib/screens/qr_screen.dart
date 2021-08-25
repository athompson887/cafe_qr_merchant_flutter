import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../DynamicTheme.dart';

class QrScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyHomeState();
  }
}

class MyHomeState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: DynamicTheme.of(context).data.primaryColor,
    );
  }
}
