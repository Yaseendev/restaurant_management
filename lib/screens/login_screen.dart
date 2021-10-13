import 'package:flutter/material.dart';
import 'package:restautant_client/widgets/login_form.dart';
import 'package:restautant_client/widgets/signup_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        shrinkWrap: true,
        children: [
          Image.asset('assets/images/Modern-Restaurant-Logo.jpg'),
          DefaultTabController(
            length: 2,
            child: Column(
              //shrinkWrap: true,
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(children: [
                    LoginForm(), Container()
                    //SignupForm(),
                    // SingleChildScrollView(),
                  ]),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
