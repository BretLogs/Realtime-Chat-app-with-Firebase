import 'package:chatapp_realtime_firebase/consts.dart';
import 'package:chatapp_realtime_firebase/services/alert_service.dart';
import 'package:chatapp_realtime_firebase/services/auth_service.dart';
import 'package:chatapp_realtime_firebase/services/navigation_services.dart';
import 'package:chatapp_realtime_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;
  late NavigationServices _navigationServices;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
  }

  String? email, password;

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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: <Widget>[
            _headerText(),
            _loginForm(),
            _createAnAccountLink(),
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
            'Hi, Welcome Back!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "Hello again, you've been missed",
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

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                hintText: 'Password',
                height: MediaQuery.sizeOf(context).height * .1,
                validationRegExp: PASSWORD_VALIDATION_REGEX,
                obscureText: true,
                onSaved: (String? value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              _loginButton(),
            ],
          )),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            bool result = await _authService.login(email!, password!);
            if (result) {
              _navigationServices.pushReplacementNamed('/home');
            } else {
              _alertService.showToast(
                text: 'Failed to Login, Please Try Again',
                icon: Icons.error,
              );
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Text("Don't have an account? "),
          GestureDetector(
            onTap: () {
              _navigationServices.pushNamed('/register');
            },
            child: const Text(
              'Sign up',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }
}
