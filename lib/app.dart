import 'package:flutter/material.dart';
import 'package:gottask/constant.dart';
import 'package:gottask/screens/splash_screen/config_screen.dart';
import 'package:gottask/screens/splash_screen/splash_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isStart;

  @override
  void initState() {
    super.initState();
    isStart();
  }

  isStart() async {
    _isStart = await currentStartState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isStart != null
        ? MaterialApp(
            title: 'Gottash',
            theme: ThemeData(
              canvasColor: Colors.transparent,
              scaffoldBackgroundColor: TodoColors.scaffoldWhite,
              appBarTheme: AppBarTheme(
                color: TodoColors.deepPurple,
              ),
              unselectedWidgetColor: Colors.black,
              accentColor: TodoColors.deepPurple,
              primaryColor: TodoColors.deepPurple,
            ),
            initialRoute: _isStart ? '/config' : '/splash',
            routes: {
              '/splash': (context) => SplashScreen(),
              '/config': (context) => ConfigScreen(),
            },
          )
        : Container(
            color: TodoColors.deepPurple,
          );
  }
}
