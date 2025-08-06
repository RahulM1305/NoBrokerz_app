import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RoleSelectionScreen(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(child: Text('GatePass', style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),),),
      ),
    );
    throw UnimplementedError();
  }
  
}