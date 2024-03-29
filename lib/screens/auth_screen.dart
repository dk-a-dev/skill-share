import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zr/helpers/colors.dart';
import 'package:zr/components/auth/gsign_in_button.dart';
import 'package:zr/helpers/dimensions.dart';
import 'get_started.dart';

FirebaseAuth _firebase = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class AuthScreen extends StatefulWidget {
  static var routeName = 'authscreen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  int numTask = 0;

  bool _isLogin = true;
  bool _passwordVisibility = false;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        UserCredential userCred =
            await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        await firestore.collection('users').doc(userCred.user!.uid).set({
          'email': _enteredEmail,
          'displayName': userCred.user!.email?.split('@')[0],
          'accCreated': 'standard',
          'numTask': 0,
        });
      }
      redirector();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void checkTask() async {
    await firestore
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .get()
        .then((value) {
      if (value.data()!['numTask'] == 0) {
        numTask = 0;
      }
    });
  }

  void redirector() {
    checkTask();
    print('numTask: $numTask');
    if (numTask == 0) {
      Navigator.of(context).pushReplacementNamed(GetStarted.routeName);
    } else {
      if (_firebase.currentUser != null) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: Dimensions.getWidth(context) * .6,
                  child: Image.asset('assets/logo-slim.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0, top: 30),
                child: Text(
                  'Login to your account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelStyle: const TextStyle(
                                color: CustomTheme.theme,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: grey,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomTheme.theme,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 8) {
                                return 'Password must be at least 8 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                            cursorColor: CustomTheme.theme,
                            obscureText: !_passwordVisibility,
                            style: const TextStyle(
                              color: CustomTheme.theme,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: _passwordVisibility
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisibility = false;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisibility = true;
                                        });
                                      },
                                    ),
                              labelStyle: const TextStyle(
                                color: CustomTheme.theme,
                              ),
                              hintText: "Password",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: grey,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomTheme.theme,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomTheme.theme,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: _submitForm,
                                child: Text(
                                  _isLogin ? "Login" : "Sign Up",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 40),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Divider(
                                color: grey,
                              )),
                              const Text(
                                " Or ",
                                style: TextStyle(
                                  color: CustomTheme.theme,
                                ),
                              ),
                              Text(
                                _isLogin ? "Login with " : "Sign Up with ",
                                style: const TextStyle(
                                  color: CustomTheme.theme,
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                color: grey,
                              )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const SignInButton(),
                          const SizedBox(height: 10),
                          Divider(
                            color: grey,
                          ),
                          const SizedBox(height: 20),
                          TextButtonTheme(
                            data: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                backgroundColor: CustomTheme.themeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Center(
                                child: Text(
                                  _isLogin
                                      ? "Don't have an Account? Register"
                                      : 'I already have an account',
                                  style: const TextStyle(
                                    color: CustomTheme.theme,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
