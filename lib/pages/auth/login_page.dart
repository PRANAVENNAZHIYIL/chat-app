import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sap_chat/pages/auth/register_page.dart';
import 'package:sap_chat/service/auth_service.dart';
import 'package:sap_chat/widgets/widgets.dart';

import '../../helper/helper_function.dart';
import '../../service/database_service.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Groupie",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Login now to see what they are talk!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Image.asset("assets/login.png"),
                          TextFormField(
                              decoration: textInputDeoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                  print(email);
                                });
                              },
                              validator: (val) =>
                                  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email"),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDeoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                                print(password);
                              });
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "password must be atlest 6 character";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    elevation: 0,
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                onPressed: () {
                                  login();
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            TextSpan(
                                text: "Dont have an account? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " Register here",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const RegisterPage());
                                        })
                                ]),
                          )
                        ],
                      )),
                ),
              ));
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          //making user status true
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .updateUserStatus(true);
          // saving the values to our shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          // ignore: use_build_context_synchronously
          nextScreenReplaced(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
