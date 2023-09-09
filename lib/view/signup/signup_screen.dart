
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker_app/Provider/provider.dart';
import 'package:fitness_tracker_app/utils/app_colors.dart';
import 'package:fitness_tracker_app/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

    bool isloading = false;
  final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    _formKey.currentState!.save();
                                    try {
                                          final String name = _nameController.text;
                            final String email = _emailController.text;
                           final String lastName = _lastNameController.text;
                                      
                                         await _auth .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                         await _firestore.collection('users').add({
                                          'name': name,
                                          'last_name': lastName,
                                          'email': email,
                                          
                                            }).then((value)  {
                                       
                                        
                                        _nameController.clear();
                                        _emailController.clear();
                                      _lastNameController.clear();
                                       _passwordController.clear();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: const Text(
                                                'Registered Successfull'),
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

                                           Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                const Text('Error Occured '),
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
                                      print(e.toString());
                                      
                                      // Registration failed, handle the error
                                    }
                                  };

  }
      

      // Registration successful, navigate to another screen or show a success message
      //
  @override
  Widget build(BuildContext context) {
      final   provider=Provider.of<ProviderClass>(context,listen: false);

      provider.scaffoldContext = context;
    
    return Consumer<ProviderClass>(
      builder: (context, value, child) {
        return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Hey there,",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RoundTextField(
                      textEditingController: _nameController,
                      validator: (value){
                        if (value!.isEmpty) {
                                return 'Please enter your First Name';
                              }
    
                              return null;
                            },
                      
                      
                      hintText: "First Name",
                      icon: "assets/icons/profile_icon.png",
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RoundTextField(
                       validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Last Name';
                              }
    
                              return null;
                            },
                      textEditingController: _lastNameController,
                        hintText: "Last Name",
                        icon: "assets/icons/profile_icon.png",
                        textInputType: TextInputType.name),
                    SizedBox(
                      height: 15,
                    ),
                  
                    RoundTextField(
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
                      textEditingController: _emailController,
                        hintText: "Email",
                        icon: "assets/icons/message_icon.png",
                        textInputType: TextInputType.emailAddress),
                    SizedBox(
                      height: 15,
                    ),
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
                      textEditingController: _passwordController,
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                             value.isChecked();},
                            icon: Icon(
                              value.isCheck
                                  ? Icons.check_box_outline_blank_outlined
                                  : Icons.check_box_outlined,
                              color: AppColors.grayColor,
                            )),
                        Expanded(
                          child: Text(
                              "By continuing you accept our Privacy Policy and\nTerm of Use",
                              style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 10,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RoundGradientButton(
                      isloading: isloading,
                      title:  "Register",
                      onPressed: () {
                        _register(context);
                      
                      }
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    SizedBox(
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
                              border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                            ),
                            child: Image.asset("assets/icons/google_icon.png",width: 20,height: 20,),
                          ),
                        ),
                        SizedBox(width: 30,),
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
                              border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                            ),
                            child: Image.asset("assets/icons/facebook_icon.png",width: 20,height: 20,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                         Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              children: [
                                const TextSpan(
                                  text: "Already have an account? ",
                                ),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800)),
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
