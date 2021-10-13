import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Login_screen.dart';

class WeclomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 150,
                      backgroundImage: AssetImage(
                          'assets/images/Modern-Restaurant-Logo.jpg'),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      'Welcome To Restaurant Management system',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 200.w,
              height: 40.h,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Text('Go',
                      style: TextStyle(
                        fontSize: 20.sp,
                      )),
                  onPressed: () {
                    // This is the navigator class and its used to navigate between pages and manage routes in the app
                    // it handles these functionalities by using the stack concept..each time we want to go to another 
                    // screen we push a new route of that screen to the stack and each time we want to go back that 
                    // route is poped out of the stack
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
