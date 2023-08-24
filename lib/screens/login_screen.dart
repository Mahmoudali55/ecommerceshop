// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable, use_key_in_widget_constructors, depend_on_referenced_packages, non_constant_identifier_names, unused_import, unnecessary_import
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/provider/adminMode.dart';
import 'package:ecommerce_shop/provider/modelHud.dart';
import 'package:ecommerce_shop/screens/admin/AdminHome.dart';
import 'package:ecommerce_shop/screens/signup_screen.dart';
import 'package:ecommerce_shop/screens/user/home.dart';
import 'package:ecommerce_shop/services/auth.dart';
import 'package:ecommerce_shop/widgets/customer_textfield.dart';
import 'package:ecommerce_shop/widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  FirebaseAuth _auths = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> SingIn2() async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    _auths.signInWithCredential(credential);
    var user = (await _auths.signInWithCredential(credential)).user;
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/drive',
      ],
    );

    await _googleSignIn.signIn();
  }

  String? _email, _password;

  final _auth = Auth();

  bool isAdmin = false;

  final adminPassword = '123456789';

  bool keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainColor,
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            Logo(),
            SizedBox(
              height: height * .1,
            ),
            CustomTextField(
              OnClick: (value) {
                _email = value;
              },
              hint: "Enter your email",
              icon: Icons.email,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                        checkColor: secondaryColor,
                        activeColor: mainColor,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value!;
                          });
                        }),
                  ),
                  Text(
                    "Remmeber Me",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            CustomTextField(
              OnClick: (value) {
                _password = value;
              },
              hint: "Enter your password",
              icon: Icons.lock,
            ),
            SizedBox(
              height: height * .05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3.5),
              child: Builder(builder: (context) {
                return TextButton(
                    onPressed: () {
                      if (keepMeLoggedIn = true) {
                        keepUserLoggedIn();
                      }
                      _validate(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ));
              }),
            ),
            SizedBox(
              height: height * .05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont have an account ? ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SignupScreen.id);
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Provider.of<AdminMode>(context, listen: false)
                          .changeIsAdmin(true);
                    },
                    child: Text(
                      "i \m an admin",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Provider.of<AdminMode>(
                        context,
                      ).isAdmin
                              ? mainColor
                              : Colors.white),
                    ),
                  )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .changeIsAdmin(false);
                      },
                      child: Text("i \m a user",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.white
                                  : mainColor)),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                SingIn2();
              },
              child: Container(
                height: 50,
                width: 10,
                child: Image.asset('assets/icon/google.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState!.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _auth.singIn(_email!, _password!);
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        } else {
          modelhud.changeisLoading(false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Something went wrong !')));
        }
      } else {
        modelhud.changeisLoading(false);

        try {
          await _auth.singIn(_email!, _password!);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIN, keepMeLoggedIn);
  }
}
