import 'dart:io';

import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/activity/activity_screen.dart';
import 'package:fitness_tracker_app/view/camera/camera_screen.dart';
import 'package:fitness_tracker_app/view/chatGpt/chatGPT.dart';
import 'package:fitness_tracker_app/view/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ActivityScreen(),
    const ChatGPT(),
    const CameraScreen(),
    const UserProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    
        onWillPop: () async {
          SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        return true;
      },
       
     child: Scaffold(
        backgroundColor: AppColors.whiteColor,
       
        body: IndexedStack(
          index: selectTab,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomAppBar(
          height: Platform.isIOS ? 70 : 65,
          color: Colors.transparent,
          padding: const EdgeInsets.all(0),
          child: Container(
            height: Platform.isIOS ? 70 : 65,
            decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, -2))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                    icon: "assets/icons/home_icon.png",
                    selectIcon: "assets/icons/home_select_icon.png",
                    isActive: selectTab == 0,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectTab = 0;
                        });
                      }
                    }),
                TabButton(
                    icon: "assets/icons/activity_icon.png",
                    selectIcon: "assets/icons/activity_select_icon.png",
                    isActive: selectTab == 1,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectTab = 1;
                        });
                      }
                    }),
                    TabButton(
                    icon: "assets/icons/bot.png",
                    selectIcon: "assets/icons/select_bot.png",
                    isActive: selectTab == 2,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectTab = 2;
                        });
                      }
                    }),
                TabButton(
                    icon: "assets/icons/camera_icon.png",
                    selectIcon: "assets/icons/camera_select_icon.png",
                    isActive: selectTab == 3,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectTab = 3;
                        });
                      }
                    }),
                TabButton(
                    icon: "assets/icons/user_icon.png",
                    selectIcon: "assets/icons/user_select_icon.png",
                    isActive: selectTab == 4,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectTab = 4;
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton(
      {Key? key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: isActive ? 8 : 12),
          Visibility(
            visible: isActive,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.secondaryG),
                  borderRadius: BorderRadius.circular(2)),
            ),
          )
        ],
      ),
    );
  }
}
