import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  DotIndicator({required this.currentIndex, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: currentIndex == index ? 10 : 4,
          height: currentIndex == index ? 10 : 4,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? Color.fromARGB(255, 44, 43, 118) // Active dot color
                : Colors.grey, // Inactive dot color
          ),
        );
      }),
    );
  }
}
