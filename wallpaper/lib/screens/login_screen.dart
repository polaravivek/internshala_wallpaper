import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/functions/useful_functions.dart';
import 'package:wallpaper/screens/homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallpaper/screens/signup_screen.dart';
import 'package:wallpaper/widgets/build_signuplogin_button.dart';
import 'package:wallpaper/widgets/build_text_fields.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  var auth = FirebaseAuth.instance;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: double.infinity,
            child: Image(
              fit: BoxFit.fill,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (!isKeyboard)
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: 150),
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
                    )
                  : Container(),
              Expanded(
                flex: 2,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
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
                          buildTextField("Email", _emailController, false,
                              TextInputType.emailAddress),
                          SizedBox(
                            height: 15,
                          ),
                          buildTextField("Password", _passwordController, true,
                              TextInputType.text),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forget Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          buildSignupLoginButton(
                              context: context,
                              label: "Login 📲",
                              tapFunction: () {
                                auth
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text.toString(),
                                  password: _passwordController.text.toString(),
                                )
                                    .then((value) async {
                                  showSnack(
                                      context: context, label: "Login Success");
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      'email', _emailController.text);
                                  prefs.setBool('isChecked', true);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                }).onError((error, stackTrace) {
                                  showSnack(
                                      context: context,
                                      label: error.toString());
                                });
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account,",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppinsThin',
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                ),
                                child: Text(
                                  'Create Now',
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'poppinsThin'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
