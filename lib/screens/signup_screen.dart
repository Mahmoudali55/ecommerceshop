// ignore_for_file: prefer_const_constructors, unused_import, unused_field, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:ecommerce_shop/constants/color.dart';
import 'package:ecommerce_shop/provider/modelHud.dart';
import 'package:ecommerce_shop/screens/user/home.dart';
import 'package:ecommerce_shop/screens/login_screen.dart';
import 'package:ecommerce_shop/services/auth.dart';
import 'package:ecommerce_shop/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_shop/widgets/customer_textfield.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  static String id = "SignupScreen";
  String? _email, _password;
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: mainColor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModelHud>(context).isLoading,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                Logo(),
                SizedBox(
                  height: height * .1,
                ),
                CustomTextField(
                  OnClick: (value) {},
                  hint: "Enter your name",
                  icon: Icons.person,
                ),
                SizedBox(
                  height: height * .02,
                ),
                CustomTextField(
                  OnClick: (value) {
                    _email = value;
                  },
                  hint: "Enter your email",
                  icon: Icons.email,
                ),
                SizedBox(
                  height: height * .02,
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
                  child: Builder(
                    builder: (context) => TextButton(
                        onPressed: () async {
                          final modelhud =
                              Provider.of<ModelHud>(context, listen: false);
                          modelhud.changeisLoading(true);
                          if (_globalKey.currentState!.validate()) {
                            _globalKey.currentState!.save();

                            try {
                              final authResult = await _auth.singUp(
                                  _email!.trim(), _password!.trim());
                              modelhud.changeisLoading(false);
                              Navigator.pushNamed(context, HomeScreen.id);
                            } catch (e) {
                              modelhud.changeisLoading(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                          modelhud.changeisLoading(false);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          "Sign UP",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do have an account ? ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
