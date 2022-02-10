import 'package:flutter/material.dart';
import 'package:order_app/blocs/login_bloc.dart';
import 'package:order_app/services/authentication.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Icon(
              Icons.account_circle,
              size: 88.0,
              color: Colors.white,
            ),
            preferredSize: Size.fromHeight(40.0)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) => TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Địa chỉ email',
                      icon: Icon(Icons.mail_outline),
                      errorText: snapshot.error),
                  onChanged: _loginBloc.emailChanged.add,
                ),
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          icon: Icon(Icons.security),
                          errorText: snapshot.error),
                      onChanged: _loginBloc.passwordChanged.add,
                    ),
              ),
              SizedBox(height: 48.0),
              _buildLoginAndCreateButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
                elevation: 16.0,
                child: Text('Đăng nhập'),
                color: Colors.lightGreen.shade200,
                disabledColor: Colors.grey.shade100,
                onPressed: snapshot.data
                    ? () => _loginBloc.loginOrCreateChanged.add('Login')
                    : null,
              ),
        ),
        FlatButton(
          child: Text('Đăng ký'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        ),
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              RaisedButton(
                elevation: 16.0,
                child: Text('Đăng ký'),
                color: Colors.lightGreen.shade200,
                disabledColor: Colors.grey.shade100,
                onPressed: snapshot.data
                    ? () =>
                    _loginBloc.loginOrCreateChanged.add('Create Account')
                    : null,
              ),
        ),
        FlatButton(
          child: Text('Đăng nhập'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }
}
