import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sap_chat/helper/helper_function.dart';
import 'package:sap_chat/pages/auth/login_page.dart';
import 'package:sap_chat/pages/home_page.dart';
import 'package:sap_chat/service/database_service.dart';
import 'package:sap_chat/shared/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserLoggedInStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // App has gone into the background
      // Place your code here to handle background events
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUserStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      // App has come back from the background
      // Place your code here to handle foreground events
      getUserLoggedInStatus();
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .updateUserStatus(true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Constants().primarycolor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//         options: FirebaseOptions(
//             apiKey: Constants.apiKey,
//             appId: Constants.appId,
//             messagingSenderId: Constants.messagingSenderId,
//             projectId: Constants.projectId));
//   } else {
//     await Firebase.initializeApp();
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isSignedIn = false;
//   @override
//   void initState() {
//     super.initState();
//     getUserLoggedInStatus();
//   }

//   getUserLoggedInStatus() async {
//     await HelperFunction.getUserLoggedInStatus().then((value) {
//       if (value != null) {
//         setState(() {
//           _isSignedIn = value;
//         });
//       }
//     });
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           primaryColor: Constants().primarycolor,
//           scaffoldBackgroundColor: Colors.white),
//       home: _isSignedIn ? const HomePage() : const LoginPage(),
//       // home: const LoginPage(),
//     );
//   }
// }

