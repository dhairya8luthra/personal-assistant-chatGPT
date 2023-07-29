import 'package:flutter/material.dart';
import 'package:personal_assistant/pallete.dart';

class featureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const featureBox({super.key,
  required this.color,
  required this.headerText,
  required this.descriptionText,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
      horizontal: 35,
      vertical:10
       ),
       decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
         ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,left: 15.0, bottom: 20.0),
          child: Column(children: [
            const SizedBox(
              height: 3,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),       
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right:20.0),
            child: Text(
                descriptionText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 14,
                ),
                ),
          ),
          ]),
        ),
    );
  }
}