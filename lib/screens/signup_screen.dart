import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/parent_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
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
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List image =  await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {

    if(_usernameController.text.contains(' ')){
      showSnackBar(context, "Please remove any spaces from your username.");
      return;
    }
    
    setState(() {
      isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      file: _image!,
    );
     
    setState(() {
      isLoading = false;
    });
    showSnackBar(context, res);
    if(res == "Registered successfully"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ParentContainer()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(

        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: MediaQuery.of(context).size.height-30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svgs/logos_instagram.svg",
                  color: primaryColor,
                  height: 60,
                ),

                const SizedBox(height: 20),
                _image != null ? 
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(_image!),
                  )
                  : 
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),

                const SizedBox(height: 10),
                GestureDetector(
                  onTap: selectImage,
                  child: Text("${_image != null ? "Change" : "Select" } Profile Photo",
                      style: const TextStyle(color: blueColor)),
                ),
                
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
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    alignment: Alignment.center,
                    child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: primaryColor)
                        )
                      : const Text("Sign up"),
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Text("Sign in.",
                            style: TextStyle(color: blueColor))),
                  ],
                )
              ],
            ),
          ),
        ),
      
    ));
  }
}
