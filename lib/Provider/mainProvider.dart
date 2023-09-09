
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainProvider extends ChangeNotifier{
  File? imageFile ;
 


 Future getImage() async{
  final returnedImage =await ImagePicker().pickImage(source: ImageSource.gallery);
  if(returnedImage!=null){

    imageFile=File(returnedImage!.path);

    notifyListeners();
    }
  
 }

 
  File? imageFile2 ;
 


 Future getImage2() async{
  final returnedImage =await ImagePicker().pickImage(source: ImageSource.camera);
  if(returnedImage!=null){

    imageFile2=File(returnedImage!.path);

    notifyListeners();
    }
  
 }

   int selectedIndex = 0;
   bool isloading = false;
   
     get source => null;

   void setLoadingTrue(){
    isloading = true;
    notifyListeners();
   }
    void setLoadingFalse(){
    isloading = false;
    notifyListeners();
   }



  void setTab(i){
    selectedIndex=i;
    notifyListeners();
  }



  
}