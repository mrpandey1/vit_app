import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vit_app/src/Shared/header.dart';
import 'package:vit_app/src/Shared/snackbar.dart';
import 'package:vit_app/src/authentication/authentication.dart';
import 'package:vit_app/src/constants.dart';
import 'package:vit_app/src/screens/HomePage.dart';

enum STATE { SIGNIN, SIGNUP, RESET }

class SignInSignUpPage extends StatefulWidget {
  final AuthFunc auth;

  SignInSignUpPage({this.auth});
  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  STATE _formState = STATE.SIGNIN;
  bool _isLoading;
  bool emailVerified = false;

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  void _showResetPasswordSent(String email) async {
    try {
      await widget.auth
          .sendPasswordResetLink(email)
          .whenComplete(() => {
                _scaffoldKey.currentState.showSnackBar(snackBar(context,
                    isErrorSnackbar: false,
                    successText: 'Email sent successfully'))
              })
          .catchError((e) => {
                _scaffoldKey.currentState.showSnackBar(snackBar(context,
                    isErrorSnackbar: true,
                    errorText: 'Email not exist or something went wrong '))
              });
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
          snackBar(context, isErrorSnackbar: true, errorText: e.toString()));
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = '';
      try {
        if (_formState == STATE.SIGNIN) {
          print(emailController.text + passwordController.text);
          userId = await widget.auth.signIn(
              emailController.text.trim(), passwordController.text.trim());
          emailVerified = await widget.auth.isEmailVerified();
          if (userId == null) {
            _scaffoldKey.currentState.showSnackBar(snackBar(context,
                isErrorSnackbar: true,
                errorText: 'Please verify your email if you have registered'));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          }
        } else if (_formState == STATE.SIGNUP) {
          userId = await widget.auth.signUp(
              emailController.text.trim(), passwordController.text.trim());
          widget.auth.sendEmailVerification();
          FirebaseAuth.instance.signOut();
          _showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        _showErrorMessage('User Already exists');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank you '),
            content: Text(
                'Verification link has been sent to your registered email'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  _changeFormToSignIn();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    setState(() {
      _formState = STATE.SIGNUP;
    });
    _clearControllers();
  }

  void _changeFormToSignIn() {
    _formKey.currentState.reset();
    setState(() {
      _formState = STATE.SIGNIN;
    });
  }

  void _changeFormToReset() {
    _formKey.currentState.reset();
    setState(() {
      _formState = STATE.RESET;
    });
    _clearControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isAppTitle: true, removeBack: false),
      body: Stack(
        children: <Widget>[
          showBody(),
          showCircularProgress(),
        ],
      ),
    );
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Container(
        child: Center(
          child: SpinKitFoldingCube(
            color: kPrimaryColor,
            duration: Duration(seconds: 2),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  Widget showBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: _isLoading
          ? Colors.black12.withOpacity(0.1)
          : Colors.black12.withOpacity(0),
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: _formState == STATE.RESET
              ? <Widget>[
                  _showEmailInput(),
                  _showResetButton(),
                  _showGotoSignInPage(),
                ]
              : <Widget>[
                  _showText(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showButton(),
                  _showAsQuestion(),
                ],
        ),
      ),
    );
  }

  Widget _showResetButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50.0,
            width: 350.0,
            child: Material(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 2.0,
              color: kPrimaryColor,
              child: InkWell(
                  onTap: () => _showResetPasswordSent(emailController.text),
                  child: Center(
                    child: Text(
                      'Send Link',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showGotoSignInPage() {
    return FlatButton(
      splashColor: Colors.transparent,
      onPressed: _changeFormToSignIn,
      child: Text(
        'Login instead ?',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _showErrorMessage(String error) {
    return snackBar(context, isErrorSnackbar: true, errorText: error);
  }

  Widget _showAsQuestion() {
    return FlatButton(
        splashColor: Colors.transparent,
        onPressed: _formState == STATE.SIGNIN
            ? _changeFormToSignUp
            : _changeFormToSignIn,
        child: _formState == STATE.SIGNIN
            ? Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Create an account ?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Already registered ?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ));
  }

  Widget _showButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50.0,
            width: 350.0,
            child: Material(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 2.0,
              color: kPrimaryColor,
              child: InkWell(
                onTap: _validateAndSubmit,
                child: _formState == STATE.SIGNIN
                    ? Center(
                        child: Text(
                          'Sign In ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Register ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPasswordInput() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Enter Password',
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value.trim().length < 8
                ? 'Password must be of more than 7 character'
                : null,
          ),
        ),
        _formState == STATE.SIGNUP
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: TextFormField(
                  maxLines: 1,
                  obscureText: true,
                  autofocus: false,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Confirm Password',
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      passwordController.text.trim() != value.trim()
                          ? 'Passwords do not match'
                          : null,
                ),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: GestureDetector(
                  onTap: _changeFormToReset,
                  child: Text('Forgot password ?'),
                ),
              ),
      ],
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Enter VIT Email Id',
          labelText: 'Email Id',
          border: OutlineInputBorder(),
        ),
        validator: (value) => !value.trim().endsWith('@vit.edu.in')
            ? 'Email is badly formatted'
            : null,
      ),
    );
  }

  Widget _showText() {
    return Hero(
      tag: 'here',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
        child: _formState == STATE.SIGNIN
            ? Center(
                child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 40,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ))
            : Center(
                child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 40,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
      ),
    );
  }
}
