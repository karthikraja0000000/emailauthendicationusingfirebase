import 'package:email_authendication/pages/home_page.dart';
import 'package:email_authendication/pages/login_page.dart';
import 'package:email_authendication/profile_picture_bloc/profile_picture_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
          BlocProvider(create: (context) => ProfilePictureBloc())
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MainPage(),
            // home: RegisterPage(),
          );
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
