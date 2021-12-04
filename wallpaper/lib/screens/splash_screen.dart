import 'package:flutter/material.dart';
import 'package:wallpaper/screens/homepage_screen.dart';
import 'package:wallpaper/screens/splash_after_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var ischecked;
  var email;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () async {
      prefs = await SharedPreferences.getInstance();
      ischecked = prefs.getBool('isChecked');
      email = prefs.getString('email');
    });
    (ischecked != null || email != null)
        ? Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()))
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashAfter(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x903B4071), Colors.transparent],
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/splashscreen.jpg'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  "Wallpaper",
                  style: TextStyle(
                      fontFamily: 'poppinsBold',
                      fontSize: 30,
                      color: Colors.white,
                      letterSpacing: 2),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Beautiful Photos",
                  style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'poppinsBold'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
