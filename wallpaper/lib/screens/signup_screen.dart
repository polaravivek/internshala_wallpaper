import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/functions/useful_functions.dart';
import 'package:wallpaper/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wallpaper/widgets/build_signuplogin_button.dart';
import 'package:wallpaper/widgets/build_text_fields.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final auth = FirebaseAuth.instance;

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

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
                          buildTextField(
                            "Email",
                            _emailController,
                            false,
                            TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          buildTextField(
                            "Password",
                            _passwordController,
                            true,
                            TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          buildTextField(
                            "Retype Password",
                            _confirmPasswordController,
                            true,
                            TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildSignupLoginButton(
                              context: context,
                              label: "Sign Up 📲",
                              tapFunction: () {
                                if (_passwordController.text.toString() ==
                                    _confirmPasswordController.text
                                        .toString()) {
                                  auth
                                      .createUserWithEmailAndPassword(
                                    email: _emailController.text.toString(),
                                    password:
                                        _passwordController.text.toString(),
                                  )
                                      .then((value) async {
                                    showSnack(
                                        context: context,
                                        label: "SignUp Success");
                                    if (isChecked) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isChecked', true);
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  }).onError((error, stackTrace) {
                                    showSnack(
                                        context: context,
                                        label: error.toString());
                                  });
                                } else {
                                  showSnack(
                                      context: context,
                                      label: "Match the Passwords...");
                                }
                              }),
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
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login())),
                                child: Text(
                                  'Login Now',
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
