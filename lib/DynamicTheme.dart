import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef Widget ThemedWidgetBuilder(BuildContext context, ThemeData data);
typedef ThemeData ThemeDataWithBrightnessBuilder(Brightness brightness);

class BrightnessSwitcherDialog extends StatelessWidget {
  const BrightnessSwitcherDialog({Key key, this.onSelectedTheme})
      : super(key: key);

  final ValueChanged<Brightness> onSelectedTheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        RadioListTile<Brightness>(
          value: Brightness.light,
          groupValue: Theme
              .of(context)
              .brightness,
          onChanged: (Brightness value) {
            onSelectedTheme(Brightness.light);
          },
          title: const Text('Light'),
        ),
        RadioListTile<Brightness>(
          value: Brightness.dark,
          groupValue: Theme
              .of(context)
              .brightness,
          onChanged: (Brightness value) {
            onSelectedTheme(Brightness.dark);
          },
          title: const Text('Spooky  👻'),
        ),
      ],
    );
  }
}

class DynamicTheme extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;

  final ThemeDataWithBrightnessBuilder data;

  final Brightness defaultBrightness;

  const DynamicTheme({Key key, this.data, this.themedWidgetBuilder, this.defaultBrightness}) : super(key: key);

  @override
  DynamicThemeState createState() => new DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return  context.findAncestorStateOfType<DynamicThemeState>();
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeData _data;

  Brightness _brightness;

  static const String _sharedPreferencesKey = "isDark";

  bool loaded = false;

  get data => _data;

  get brightness => _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;
    _data = widget.data(_brightness);

    loadBrightness().then((dark) {
      setState(() {
        _brightness = dark ? Brightness.dark : Brightness.light;
        _data = widget.data(_brightness);
        loaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = widget.data(_brightness);
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data(_brightness);
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _data);
  }

  void setBrightness(Brightness brightness) async {
    setState(() {
      this._data = widget.data(brightness);
      this._brightness = brightness;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sharedPreferencesKey, brightness == Brightness.dark ? true : false);
  }

  void setThemeData(ThemeData data) {
    setState(() {
      this._data = data;
    });
  }

  Future<bool> loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_sharedPreferencesKey) ?? false);
  }
}