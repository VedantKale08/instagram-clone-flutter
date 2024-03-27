import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svgs/logos_instagram.svg",
            color: Colors.white,
            height: 60,
          ),
          const SizedBox(height: 20),
          InputField(
            hintText: "Email or Username",
            textInputType: TextInputType.text,
            textEditingController: _emailController,
          ),
          const SizedBox(height: 20),
          InputField(
            hintText: "Password",
            textInputType: TextInputType.visiblePassword,
            textEditingController: _passwordController,
            isPass: true,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              print("Sign in.....");
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              alignment: Alignment.center,
              child: const Text("Sign in"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(color: secondaryColor),
              ),
              GestureDetector(
                  onTap: () {
                    print("Sign up");
                  },
                  child: const Text("Sign up.",
                      style: TextStyle(color: blueColor))),
            ],
          )
        ],
      ),
    )));
  }
}
