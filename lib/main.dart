import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We used Screen util package to make the design responsive
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: () {
          // This is the root of the app
          return MaterialApp(
              title: 'Restaurant App',
              debugShowCheckedModeBanner: false,
              home: HomeScreen(), //WeclomeScreen(),
              );
        });
  }
}
