import 'dart:io';

import 'package:chatapp_realtime_firebase/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: <Widget>[
            _headerText(),
            _registerForm(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Let\'s get going!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Register an account using the form below',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * .6,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * .05,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            _profilePictureSelection(),
          ],
        ),
      ),
    );
  }

  Widget _profilePictureSelection() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.width * .15,
      backgroundImage: selectedImage != null ? FileImage(selectedImage!) : const NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
    );
  }
}
