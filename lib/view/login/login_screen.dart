import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker_app/Provider/mainProvider.dart';
import 'package:fitness_tracker_app/Provider/provider.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/dashboard/dashboard_screen.dart';
import 'package:fitness_tracker_app/view/home/home_screen.dart';
import 'package:fitness_tracker_app/view/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  final _auth = FirebaseAuth.instance;


  void login(BuildContext context) async{
      if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    _formKey.currentState!.save();
                                    try {
                                   
                                          await _auth.signInWithEmailAndPassword(
                                        email: _email.text,
                                        password: _password.text,
                                      )
                                          .then((value) {
                                        _email.clear();
                                        _password.clear();
                                        setState(() {
                                          isloading = false;
                                        });
                                
                                         Navigator.pushNamed(context, DashboardScreen.routeName);

                                     
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                const Text('Error Occured'),
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  100,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        );

                                        setState(() {
                                          isloading = false;
                                        });
                                      });

                                    
                                    } catch (e) {
                                      // Registration failed, handle the error
                                    }
                                  }
                                }
                            
  
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;
  

  @override
  Widget build(BuildContext context) {
  final   provider=Provider.of<ProviderClass>(context,listen: false);

      provider.scaffoldContext = context;

    var media = MediaQuery.of(context).size;
    return Consumer<ProviderClass>(
      builder: (context, value, child) {
        return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: media.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: media.width * 0.03,
                          ),
                          const Text(
                            "Hey there,",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: media.width * 0.01),
                          const Text(
                            "Welcome Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: media.width * 0.08),
                     RoundTextField(
                      textEditingController: _email,
                       validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                    
                                    final emailRegex = RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                    
                                    return null;
                                  },
                        hintText: "Email",
                        icon: "assets/icons/message_icon.png",
                        textInputType: TextInputType.emailAddress),
                    SizedBox(height: media.width * 0.05),
                     RoundTextField(
                         validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
      
                                return null;
                              },
                        textEditingController: _password,
                        hintText: "Password",
                        icon: "assets/icons/lock_icon.png",
                        textInputType: TextInputType.text,
                        isObscureText: value.iconPressed==true?false:true,
                        rightIcon: TextButton(
                            onPressed: () {
                              value.iconPress();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                child:value.iconPressed==true ?Icon(Icons.visibility,color: AppColors.grayColor,):Icon(Icons.visibility_off,color: AppColors.grayColor,)
                                )
                                ),
                      ),
                    SizedBox(height: media.width * 0.04),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: const Text("Forgot your password?",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 13,
                          )),
                    ),
                    SizedBox(height: media.width * 0.03),
                    RoundGradientButton(
                      title: "Login",
                      onPressed: () {
                        login(context);
                      },
                      isloading: isloading,
                    ),
                    SizedBox(height: media.width * 0.03),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        )),
                        Text("  Or  ",
                            style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                        Expanded(
                            child: Container(
                          width: double.maxFinite,
                          height: 1,
                          color: AppColors.grayColor.withOpacity(0.5),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.googleLogin();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primaryColor1.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              "assets/icons/google_icon.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.signInWithFacebook();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primaryColor1.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              "assets/icons/facebook_icon.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              children: [
                                 TextSpan(
                                  text: "Don't have an account yet? ",
                                ),
                                TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ]),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
        
      },
      
    );
  }
}
