
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class LoadingWidget extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    return const Center(child: SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(

          strokeWidth: 2,
        )));
    // return SpinKitSquareCircle(color: CustomColors.lightGreen,
    // );
  }}
