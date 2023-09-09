import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/dashboard/dashboard_screen.dart';
import 'package:fitness_tracker_app/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(color: AppColors.blackColor),
        );
        else if(snapshot.hasData){
          return DashboardScreen();

        }
        else if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        else{
          return OnBoardingScreen();
        }
      }),
    );
  }
}