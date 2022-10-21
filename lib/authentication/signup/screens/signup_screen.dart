// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/authentication/common/model/user_model.dart';
import '/authentication/common/widgets/button_widget.dart';
import '/authentication/common/widgets/input_field_widget.dart';
import '/screens/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //  firebase

  final _auth = FirebaseAuth.instance;

  //  string for displaying the error Message

  String? errorMessage;

  //  our form key

  final _formKey = GlobalKey<FormState>();

  //  text controller

  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45),

                    //  first name field & its control

                    TextInputField(
                      inputController: _firstNameController,
                      formValidator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstNameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      icon: Icons.person,
                      textName: 'First Name',
                    ),
                    const SizedBox(height: 20),

                    // second name field & its control

                    TextInputField(
                      inputController: _secondNameController,
                      formValidator: (value) {
                        if (value!.isEmpty) {
                          return ("Second Name cannot be Empty");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _secondNameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      icon: Icons.person,
                      textName: 'Second Name',
                    ),
                    const SizedBox(height: 20),

                    //  email field & its control

                    TextInputField(
                      inputController: _emailController,
                      formValidator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _emailController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      icon: Icons.mail,
                      textName: 'Email',
                    ),
                    const SizedBox(height: 20),

                    //  password field & its control

                    TextInputField(
                      inputController: _passwordController,
                      toHide: true,
                      formValidator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _passwordController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      icon: Icons.vpn_key,
                      textName: 'Password',
                    ),
                    const SizedBox(height: 20),

                    //  confirm password field & its control

                    TextInputField(
                      inputController: _confirmPasswordController,
                      toHide: true,
                      formValidator: (value) {
                        if (_confirmPasswordController.text !=
                            _passwordController.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmPasswordController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      icon: Icons.vpn_key,
                      textName: 'Confirm Password',
                    ),
                    const SizedBox(height: 20),

                    //  signUp button control

                    Button(
                      onPressed: () {
                        signUp(
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                      btnName: 'Sign Up',
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // signUp function

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then(
              (value) => {
                postDetailsToFirestore(),
              },
            )
            .catchError(
          (e) {
            Fluttertoast.showToast(msg: e!.message);
          },
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = _firstNameController.text;
    userModel.secondName = _secondNameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }
}
