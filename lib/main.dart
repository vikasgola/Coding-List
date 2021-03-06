import 'package:flutter/material.dart';
import 'package:coding_list/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getTheme() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isDark") ?? ThemeMode.system == ThemeMode.dark;
}

Future<List<int>> getVisibleSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final out = prefs.getStringList("visible-settings") ??
      [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
        "12",
        "13"
      ];
  return out.map((i) => int.parse(i)).toList();
}

main() {
  runApp(new RestartWidget());
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();
  bool isDarkTheme = ThemeMode.system == ThemeMode.dark;
  List<int> visible = [];

  Future<void> updateDetails() async {
    bool temp = await getTheme();
    List<int> temp2 = await getVisibleSettings();

    setState(() {
      this.isDarkTheme = temp;
      this.visible = temp2;
    });
  }

  @override
  initState() {
    super.initState();
    updateDetails();
  }

  void restartApp() {
    updateDetails();
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding List',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: this.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: new HomePage("", this.visible),
    );
  }
}
