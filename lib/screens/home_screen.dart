import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  double _overlap = 0;
@override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap >= 0) {
      setState(() {
        _overlap = overlap;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
        ],
      ),
      // drawer: ,
      body: Center(
        child: SizedBox(
          width: 200.w,
          height: 50.h,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
            child: Text('Make a reservation',
                style: TextStyle(
                  fontSize: 18.sp,
                )),
            onPressed: () async {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Color(0xFF737373),
                context: context,
                isDismissible: true,
                enableDrag: true,
                builder: (context) {
                  return Container(
                     height: MediaQuery.of(context).size.height - 80.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
IconButton(
                        icon: Icon(
                          Icons.horizontal_rule,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Divider(color: Colors.black, thickness: 1.2),
                      Expanded(child:  Padding(
                      padding: EdgeInsets.only(bottom: _overlap),
                      ),)

                    ]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
