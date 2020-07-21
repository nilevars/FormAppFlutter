import 'package:flutter/material.dart';
import 'models/user.dart';
import 'dart:async';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  Future<User> _futureUser;
  final _passwordController = TextEditingController();

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value.length <= 8) {
          return "Password should be min 8 characters long";
        }
        return null;
      },
      onSaved: (val) => setState(() => _user.password = val),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Full Name'),
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your Full Name";
        }
        return null;
      },
      onSaved: (val) => setState(() => _user.name = val),
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your Email";
        } else if (!isEmail(value)) {
          return "Please Enter a valid Email";
        }
        return null;
      },
      onSaved: (val) => setState(() => _user.email = val),
    );
  }

  bool isEmail(String value) {
    String regex =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(regex);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  Widget _phoneField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Phone'),
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your Phone Number";
        }
        return null;
      },
      onSaved: (val) => setState(() => _user.phone = val),
    );
  }

  Widget _submitButton(context) {
    print("submit clicked");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: RaisedButton(
        color: Colors.blueGrey,
        textColor: Colors.white,
        child: Text('Save'),
        onPressed: () {
          final form = _formKey.currentState;
          if (form.validate()) {
            print("form valid");
            form.save();
            setState(() {
              _futureUser = _user.save();
            });
          }
        },
      ),
    );
  }

  Widget displayForm(context) {
    return Builder(
        builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: [
                  _nameField(),
                  _passwordField(),
                  _emailField(),
                  _phoneField(),
                  _submitButton(context),
                ],
              ),
            ));
  }

  Widget displayUser() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        // return Text("Data Successfully submitted");
        if (snapshot.hasData) {
          return Center(
            child: Text(
                "Dear ${snapshot.data.name}, Your Data has been Successfully Submitted"),
          );
          // return Text(snapshot.data.name);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
        child: (_futureUser == null) ? displayForm(context) : displayUser(),
      ),
    );
  }
}
