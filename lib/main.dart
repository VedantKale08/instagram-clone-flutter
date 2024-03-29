import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/parent_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Instagram clone",
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor
          ),
          home:StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(), //it runs when user signed in and signed out
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){ //when connection is active
                if(snapshot.hasData){       //when snapshot has data return home
                  return const ParentContainer();
                }else if (snapshot.hasError){     //when snapshot has error return error
                  return Scaffold(
                      body: Center(
                          child: Text(
                    "${snapshot.error}",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  )));
                }
              }
              else if(snapshot.connectionState == ConnectionState.waiting){   //when connection is waiting return loader
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator(color: primaryColor,)),
                );
              }
      
              return const LoginScreen(); //when snapshot does not have any data.
            },
          )
      ),
    );
  }
}
