import 'dart:io';

import 'package:chatapp_realtime_firebase/consts.dart';
import 'package:chatapp_realtime_firebase/models/user_profile.dart';
import 'package:chatapp_realtime_firebase/services/alert_service.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:chatapp_realtime_firebase/services/database_service.dart';
import 'package:chatapp_realtime_firebase/services/media_service.dart';
import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:chatapp_realtime_firebase/services/storage_service.dart';
import 'package:chatapp_realtime_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late MediaService _mediaService;
  late NavigationServices _navigationServices;
  late AuthService _authService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  File? selectedImage;
  String? email, password, name;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationServices = _getIt.get<NavigationServices>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

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
            if (!isLoading) _registerForm(),
            if (!isLoading) _loginAccountLink(),
            if (isLoading)
              const Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              ))
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
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _profilePictureSelection(),
            CustomFormField(
              hintText: 'Name',
              height: MediaQuery.sizeOf(context).height * .1,
              validationRegExp: NAME_VALIDATION_REGEX,
              onSaved: (String? value) {
                setState(() {
                  name = value;
                });
              },
            ),
            CustomFormField(
              hintText: 'Email',
              height: MediaQuery.sizeOf(context).height * .1,
              validationRegExp: EMAIL_VALIDATION_REGEX,
              onSaved: (String? value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              hintText: 'password',
              height: MediaQuery.sizeOf(context).height * .1,
              validationRegExp: PASSWORD_VALIDATION_REGEX,
              onSaved: (String? value) {
                setState(() {
                  password = value;
                });
              },
            ),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _profilePictureSelection() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * .15,
        backgroundImage: selectedImage != null ? FileImage(selectedImage!) : const NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) && selectedImage != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpUrl = await _storageService.uploadUserPfp(
                  file: selectedImage!,
                  uid: _authService.user!.uid,
                );
                if (pfpUrl != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                      uid: _authService.user!.uid,
                      name: name,
                      pfpURL: pfpUrl,
                    ),
                  );
                  _alertService.showToast(
                    text: 'User Registered Successfully',
                    icon: Icons.check,
                  );
                  _navigationServices.goBack();
                  _navigationServices.pushReplacementNamed('/home');
                } else {
                  throw Exception('Unable to upload user profile picture');
                }
              } else {
                throw Exception('Unable to register user');
              }
            }
          } catch (e) {
            _alertService.showToast(
              text: 'Failed to register, Please try Again!',
              icon: Icons.check,
            );
          }
          setState(() {
            isLoading = false;
            selectedImage = null;
          });
        },
        child: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Text('Already have an account? '),
          GestureDetector(
            onTap: () {
              _navigationServices.goBack();
            },
            child: const Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
