import 'package:flutter/material.dart';
import 'package:wallpaper/screens/login_screen.dart';
import 'package:wallpaper/screens/signup_screen.dart';
import 'package:wallpaper/widgets/build_signuplogin_button.dart';

class SplashAfter extends StatefulWidget {
  const SplashAfter({Key? key}) : super(key: key);

  @override
  State<SplashAfter> createState() => _SplashAfterState();
}

class _SplashAfterState extends State<SplashAfter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/splashscreen.jpg'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x903B4071), Colors.white10],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 150),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Wallpaper",
                    style: TextStyle(
                        fontFamily: 'poppinsBold',
                        fontSize: 28,
                        color: Colors.white,
                        letterSpacing: 1),
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
                        fontFamily: 'poppinsThin'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppinsBold',
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Explore beautiful wallpapers and set them in your devices.",
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppinsThin',
                        // fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildSignupLoginButton(
                    context: context,
                    label: "Sign Up with Email",
                    tapFunction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account,',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppinsThin',
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())),
                        child: Text(
                          'Login Now',
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontFamily: 'poppinsThin'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
