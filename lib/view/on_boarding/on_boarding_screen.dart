import 'package:fitness_tracker_app/Provider/mainProvider.dart';
import 'package:fitness_tracker_app/Provider/provider.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/on_boarding/widgets/pages.dart';
import 'package:fitness_tracker_app/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  static String routeName = "/OnBoardingScreen";
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
List pageList = [
    {
        "title": "Set and Achieve",
        "subtitle": "Discover and achieve your goals with our guided assistance, tracking your progress all the way.",
        "image": "assets/images/on_board1.jpeg"
    },
    {
        "title": "Embrace the Challenge",
        "subtitle": "Embrace the journey towards your goals; temporary discomfort leads to everlasting success.",
        "image": "assets/images/on_board2.png"
    },
    {
        "title": "Nourish Your Body",
        "subtitle": "Embark on a healthy lifestyle journey with personalized daily diet plans for a joyful eating experience.",
        "image": "assets/images/on_board3.jpeg"
    },
    {
        "title": "Enhance Your Sleep",
        "subtitle": "Elevate your sleep quality for brighter mornings and improved overall well-being.",
        "image": "assets/images/on_board4.png"
    }
];


  @override
  Widget build(BuildContext context) {
    
          final mainProvider=Provider.of<MainProvider>(context,listen: false);

    return Consumer<MainProvider>(
      builder: (context, value, child) {
        return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: pageList.length,
              onPageChanged: (i) {
                value.setTab(i);
            
              },
              itemBuilder: (context, index) {
                var temp = pageList[index] as Map? ?? {};
                return Pages(obj: temp);
              },
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor1,
                      value: (mainProvider.selectedIndex+1) / 4,
                      strokeWidth: 3,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      
                        borderRadius: BorderRadius.circular(35),
                        color: AppColors.primaryColor1),
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigate_next,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () {
                        if (mainProvider.selectedIndex < 3) {
                          mainProvider.selectedIndex = mainProvider.selectedIndex + 1;
                          pageController.animateToPage(mainProvider.selectedIndex,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInSine);
                        }
                        else{
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
        
      },
       
    );
  }
}
