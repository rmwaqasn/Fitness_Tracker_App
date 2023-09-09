
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracker_app/Provider/mainProvider.dart';
import 'package:fitness_tracker_app/Provider/provider.dart';
import 'package:fitness_tracker_app/homePage.dart';
import 'package:fitness_tracker_app/routes.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (context) => ProviderClass()),
        ChangeNotifierProvider(create: (context) => MainProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness',
        debugShowCheckedModeBanner: false,
        routes: routes,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor1,
          useMaterial3: true,
          fontFamily: "Poppins"
        ),
        home: HomePage(),
      ),
    );
  }
}

