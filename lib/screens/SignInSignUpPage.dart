import 'package:flutter/material.dart';
import 'package:vit_app/authentication/authentication.dart';

enum STATE { SIGNIN, SIGNUP }

class SignInSignUpPage extends StatefulWidget {
  AuthFunc auth;
  VoidCallback onSignIn;
  SignInSignUpPage({this.auth, this.onSignIn});
  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  @override
  void initState() {
    super.initState();
    _errormessage = '';
    _isLoading = false;
  }

  final _formKey = new GlobalKey<FormState>();
  String _email, _password, _errormessage;
  STATE _formState = STATE.SIGNIN;
  bool _isIos, _isLoading;
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateandsubmit() async {
    setState(() {
      _errormessage = '';
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = '';
      try {
        if (_formState == STATE.SIGNIN) {
          userId = await widget.auth.signIn(_email, _password);
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _formState == STATE.SIGNIN)
          widget.onSignIn();
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
          if (_isIos)
            _errormessage = e.details;
          else
            _errormessage = e.message;
        });
      }
    }
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thank you '),
            content: Text('Link has been sent '),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    _changeFormToSignIn();
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errormessage = '';
    setState(() {
      _formState = STATE.SIGNUP;
    });
  }

  void _changeFormToSignIn() {
    _formKey.currentState.reset();
    _errormessage = '';
    setState(() {
      _formState = STATE.SIGNIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vit App'),
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
        child: CircularProgressIndicator(),
      );
    return Container(
      height: 0,
      width: 0,
    );
  }

  Widget showBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
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

  Widget _showErrorMessage() {
    if (_errormessage.length > 0 && _errormessage != null) {
      return new Text(
        _errormessage,
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
        onPressed: _formState == STATE.SIGNIN
            ? _changeFormToSignUp
            : _changeFormToSignIn,
        child: _formState == STATE.SIGNIN
            ? Text(
                'Create  an account ?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              )
            : Text(
                'Already registered ?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ));
  }

  Widget _showButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
        child: SizedBox(
          height: 40,
          child: RaisedButton(
            onPressed: _validateandsubmit,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.blue,
            child: _formState == STATE.SIGNIN
                ? Text(
                    'Sign In ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                : Text(
                    'Register ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
          ),
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Enter Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.length < 8
            ? 'Password must be of more than 7 character'
            : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Enter Password',
          icon: Icon(Icons.mail, color: Colors.grey),
        ),
        validator: (value) => value.isEmpty ? 'Email can not be empty' : null,
        onSaved: (value) => _email = value.trim(),
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
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ))
            : Center(
                child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              )),
      ),
    );
  }
}
