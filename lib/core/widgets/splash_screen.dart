import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatelessWidget {
  final MyApp myApp;
  final Duration duration;
  const SplashScreen({
    Key? key,
    required this.myApp,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pokemondo',
      debugShowCheckedModeBanner: false,
      home: ShowSplashScreen(
        myApp: myApp,
        duration: duration,
      ),
    );
  }
}

class ShowSplashScreen extends StatefulWidget {
  final MyApp myApp;
  final Duration duration;
  const ShowSplashScreen({
    Key? key,
    required this.myApp,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<ShowSplashScreen> createState() => _ShowSplashScreenState();
}

class _ShowSplashScreenState extends State<ShowSplashScreen> {
  @override
  void initState() {
    _updateAppTheme();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Future.delayed(widget.duration);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget.myApp,
      ),
    );
    super.didChangeDependencies();
  }

  void _updateAppTheme() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff3558cd),
      statusBarColor: Color(0xff3558cd),
      statusBarIconBrightness: Brightness.light,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3558cd),
      body: Center(
        child: Image.asset(
          "assets/images/pokemondo_splash.png",
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
