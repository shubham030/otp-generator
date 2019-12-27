import 'package:flutter/material.dart';
import 'package:otp_generator/ui/screens/otp_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otp Generator',
      home: OtpGenerator(),
    );
  }
}


