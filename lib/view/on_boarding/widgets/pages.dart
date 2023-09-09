import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class Pages extends StatelessWidget {

  final Map obj;

  const Pages({Key? key, required this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(

      children:[
                    Image.asset(obj["image"],width: size.width,height:size.height,fit: BoxFit.cover),

        
         Positioned(
          top:500,
           child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
                 width: size.width,
                 height: size.height,
                 child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(obj["title"],style:const TextStyle(color: AppColors.blackColor,fontSize: 24,fontWeight: FontWeight.w700),),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 315,
                        child: Text(
                          obj["subtitle"],
                          style: const TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ],
                 ),
               ),
         ),]
    );
  }
}
