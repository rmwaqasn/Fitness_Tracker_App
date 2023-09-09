
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker_app/view/dashboard/dashboard_screen.dart';
import 'package:fitness_tracker_app/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


class ProviderClass extends ChangeNotifier{

    bool isCheck=false;
 void isChecked(){
  isCheck = !isCheck;
  notifyListeners();

 }
                                
                           

bool iconPressed=false;

void iconPress(){
  iconPressed=!iconPressed;
  notifyListeners();
}








    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

    final FacebookAuth facebookAuth = FacebookAuth.instance;
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();
    // getting the profile
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

    final profile = jsonDecode(graphResponse.body);

    if (result.status == LoginStatus.success) {
      try {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential).then((value) {
    ScaffoldMessenger.of(scaffoldContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Login Successful'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(scaffoldContext!).size.height - 100,
          left: 10,
          right: 10,
        ),
      ),
    );

    // Navigate to CompleteProfileScreen using the stored context
    Navigator.pushNamed(scaffoldContext!, DashboardScreen.routeName);

  }).onError((error, stackTrace) {
     print('An error occurred: $error');
  ScaffoldMessenger.of(scaffoldContext!)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                const Text('Error Occured'),
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(scaffoldContext!)
                                                      .size
                                                      .height -
                                                  100,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        );

  });
        // saving the values
        _name = profile['name'];
        _email = profile['email'];
        _imageUrl = profile['picture']['data']['url'];
        _uid = profile['id'];
        _hasError = false;
        _provider = "FACEBOOK";
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }











  

  





  final googleSignIn=GoogleSignIn();
  BuildContext?   scaffoldContext; 

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;


  Future googleLogin() async {

   try {
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return;
  }
  _user = googleUser;
  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    ScaffoldMessenger.of(scaffoldContext!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Login Successful'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(scaffoldContext!).size.height - 100,
          left: 10,
          right: 10,
        ),
      ),
    );

    // Navigate to CompleteProfileScreen using the stored context
    Navigator.pushNamed(scaffoldContext!, DashboardScreen.routeName);

  });

  notifyListeners();
} catch (e) {
  print('An error occurred: $e');
  ScaffoldMessenger.of(scaffoldContext!)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content:
                                                const Text('Error Occured'),
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(scaffoldContext!)
                                                      .size
                                                      .height -
                                                  100,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        );
                                notifyListeners();

}


}
void logout2(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // await googleSignIn.disconnect();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Logout Successful'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 10,
          right: 10,
        ),
      ),
    );

    Navigator.pushNamed(context, LoginScreen.routeName);
    notifyListeners();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Error Occurred'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 10,
          right: 10,
        ),
      ),
    );

    print('An error occurred: $e');
  }
}




}