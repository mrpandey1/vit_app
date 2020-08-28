import 'package:flutter/material.dart';
import 'package:vit_app/src/authentication/authentication.dart';
import 'package:vit_app/src/constants.dart';

enum STATE { SIGNIN, SIGNUP, RESET }

class SignInSignUpPage extends StatefulWidget {
  final AuthFunc auth;
  final VoidCallback onSignIn;
  SignInSignUpPage({this.auth, this.onSignIn});
  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  STATE _formState = STATE.SIGNIN;
  bool _isIos, _isLoading;

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _isLoading = false;
  }

  void _showResetPasswordSent(String email) async {
    SnackBar snackBar = SnackBar(
      content: Text('Email not exist or something went wrong '),
      backgroundColor: Colors.red,
    );
    SnackBar snackBar2 = SnackBar(
      content: Text('Reset link sent to ' + email),
      backgroundColor: Colors.green,
    );
    await widget.auth.sendPasswordResetLink(email).then((value) {
      _scaffoldKey.currentState.showSnackBar(snackBar2);
      _clearControllers();
      _changeFormToSignIn();
    }).catchError((e) => {_scaffoldKey.currentState.showSnackBar(snackBar)});
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
      _errorMessage = '';
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = '';
      try {
        if (_formState == STATE.SIGNIN) {
          userId = await widget.auth.signIn(
              emailController.text.trim(), passwordController.text.trim());
          _clearControllers();
          if (userId == null) {
            setState(() {
              _isLoading = false;
            });
            SnackBar snackBar = SnackBar(
              content: Text('Email is not verified (Check your inbox)'),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        } else if (_formState == STATE.SIGNUP) {
          userId = await widget.auth.signUp(
              emailController.text.trim(), passwordController.text.trim());
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          _clearControllers();
        } else {
          //reset goes here

        }
        setState(() {
          _isLoading = false;
        });
        if (userId != null) {
          if (userId.length > 0 && userId != null && _formState == STATE.SIGNIN)
            widget.onSignIn();
        }
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
          if (_isIos)
            _errorMessage = e.details;
          else
            _errorMessage = e.message;
        });
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
    _errorMessage = '';
    setState(() {
      _formState = STATE.SIGNUP;
    });
    _clearControllers();
  }

  void _changeFormToSignIn() {
    _formKey.currentState.reset();
    _errorMessage = '';
    setState(() {
      _formState = STATE.SIGNIN;
    });
    _clearControllers();
  }

  void _changeFormToReset() {
    _formKey.currentState.reset();
    _errorMessage = '';
    setState(() {
      _formState = STATE.RESET;
    });
    _clearControllers();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('VIT App'),
      ),
      body: Stack(
        children: <Widget>[
          showBody(),
          showCircularProgress(),
        ],
      ),
    );
  }

  Widget showCircularProgress() {
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: kPrimaryColor,
        ),
      );
    return Container(
      height: 0,
      width: 0,
    );
  }

  Widget showBody() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: _formState == STATE.RESET
              ? <Widget>[
                  _showEmailInput(),
                  _showResetButton(),
                  _showGotoSigninPage(),
                ]
              : <Widget>[
                  _showText(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showButton(),
                  _showAsQuestion(),
                  _showErrorMessage(),
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

  Widget _showGotoSigninPage() {
    return FlatButton(
      splashColor: Colors.transparent,
      onPressed: _changeFormToSignIn,
      child: Text(
        'Login instead ?',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
          color: Colors.red,
          height: 1,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
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
              icon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
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
                    hintText: 'Confirm Password',
                    icon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
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
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Enter VIT Email Id',
          icon: Icon(Icons.mail, color: Colors.grey),
        ),
        validator: (value) =>
            !value.endsWith('@vit.edu.in') ? 'Email is badly formatted' : null,
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
