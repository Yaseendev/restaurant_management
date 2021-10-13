import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:restautant_client/models/user.dart';
import 'package:restautant_client/utils/services/network_service.dart';

class SignupForm extends StatefulWidget {
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool viewPassword = false;
  String _email = '';
  String _name = '';
  String _zipcode ='';
  String _address ='';
  String _city='';
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
                  labelText: 'Full name',
                ),
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (!GetUtils.isLengthBetween(value,6,15)) return 'Enter a valid name';
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
                  labelText: 'Zipcode',
                ),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  _zipcode = value;
                },
                validator: (value) {
                  if (!GetUtils.isLengthEqualTo(value,6)) return 'Enter a valid zipcode';
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
                  labelText: 'address',
                ),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  _address = value;
                },
                validator: (value) {
                  if (!GetUtils.isLengthBetween(value,10,40)) return 'Enter a valid address';
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
                  labelText: 'City',
                ),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  _city = value;
                },
                validator: (value) {
                  if (!GetUtils.isLengthBetween(value,3,40)) return 'Enter a valid city';
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
                      print('Signup button pressed!');
                      if (_formKey.currentState!.validate()) {
                        signupUser(_email,_name,_zipcode ,_address,_city, _pass);
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void signupUser(String email,String name,String zipcode ,String address,String city, String password) async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         backgroundColor: Colors.transparent,
    //         title: Center(
    //             child: CircularProgressIndicator(
    //               backgroundColor: Colors.transparent,
    //             )),
    //       );
    //     });
    final networkServ = NetworkService(Dio(BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 50000,
      contentType: 'application/json',
    )));
    final resMap = await networkServ.signupUser(email,name,zipcode ,address,city, password);
    User? res = resMap!['user'];
    if (res != null) {
      // GO to home page
      print('Success');
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resMap['error'])));
    }
  }
}
