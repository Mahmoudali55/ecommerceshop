// ignore_for_file: unused_element, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:ecommerce_shop/constants/color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final Function(String?) OnClick;
  String _errorMessage(String str) {
    switch (hint) {
      case 'Enter your name':
        return 'Name is empty';
      case 'Enter your email':
        return 'email is empty';
      case 'Enter your password':
        return 'password is empty';
    }
    return '';
  }

  CustomTextField(
      {Key? key, required this.icon, required this.hint, required this.OnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return _errorMessage(hint);
          }
        },
        onSaved: OnClick,
        obscureText: hint == 'Enter your password' ? true : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: mainColor,
          ),
          filled: true,
          fillColor: secondaryColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
