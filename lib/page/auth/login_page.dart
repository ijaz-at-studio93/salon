import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final  bool splashPage;
  const LoginPage({super.key,this.splashPage =  false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
