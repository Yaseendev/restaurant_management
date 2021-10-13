import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:restautant_client/models/user.dart';
import 'package:restautant_client/utils/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool viewPassword = false;
  bool _remeberUser = false;
  String _email = '';
  String _pass = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'example@email.com',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  _email = value;
                },
                validator: (value) {
                  if (!GetUtils.isEmail(value!)) return 'Email is invalid';
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: viewPassword
                      ? IconButton(
                          icon: Icon(Icons.visibility_off),
                          onPressed: () => setState(() {
                            viewPassword = false;
                          }),
                        )
                      : IconButton(
                          onPressed: () => setState(() {
                                viewPassword = true;
                              }),
                          icon: Icon(Icons.visibility)),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: viewPassword ? false : true,
                onChanged: (value) {
                  _pass = value;
                },
                validator: (value) {
                  if (value!.isEmpty) return 'Password must not be empty';
                  return null;
                },
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _remeberUser,
                        onChanged: (bool? value) {
                          setState(() {
                            _remeberUser = value!;
                          });
                        },
                      ),
                      Text('Remeber Me')
                    ],
                  ),
                  TextButton(onPressed: () {}, child: Text('Forgot Password?')),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40.h,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: Text('Login',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () async {
                      print('Login button pressed!');
                      if (_formKey.currentState!.validate()) {
                        loginUser(_email, _pass);
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void loginUser(String email, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            title: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            )),
          );
        });
    final networkServ = context.read(networkServiceProvider);

    final resMap = await networkServ.loginUser(email, password);
    User? res = resMap!['user'];
    if (res != null) {
      Navigator.of(context).pop();
      // GO to home page
      print('Success');
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resMap['error'])));
    }
  }
}
