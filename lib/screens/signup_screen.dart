import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
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
            color: primaryColor,
            height: 60,
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(height: 10),
          const Text("Select Profile Photo",
              style: TextStyle(color: blueColor)),
          const SizedBox(height: 30),
          InputField(
            hintText: "Username",
            textInputType: TextInputType.text,
            textEditingController: _usernameController,
          ),
          const SizedBox(height: 20),
          InputField(
            hintText: "Email",
            textInputType: TextInputType.emailAddress,
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
          InputField(
            hintText: "Bio",
            textInputType: TextInputType.text,
            textEditingController: _bioController,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async{
              String res = await AuthMethod().signUpUser(
                email:_emailController.text,
                username:_usernameController.text,
                password:_passwordController.text,
                bio:_bioController.text,
              );
              print("result------------");
              print(res);
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              alignment: Alignment.center,
              child: const Text("Sign up"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: secondaryColor),
              ),
              GestureDetector(
                  onTap: () {
                    print("Sign up");
                  },
                  child: const Text("Sign in.",
                      style: TextStyle(color: blueColor))),
            ],
          )
        ],
      ),
    )));
  }
}
