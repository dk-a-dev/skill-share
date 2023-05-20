import 'package:flutter/material.dart';
import 'package:zr/colors/colors.dart';

class ScreenThree extends StatelessWidget {
  static var routeName = 'ScreenThree';
  const ScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 600,
            color: grey,
            width: width,
            child: Image.asset(
              'assets/three.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'We got you covered!',
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'We have come up with the solutions to help you in your learning journey.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: width - 50,
        height: 80,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: Colors.grey,
                  size: 15,
                ),
                const Icon(
                  Icons.circle,
                  color: Colors.grey,
                  size: 15,
                ),
                Icon(
                  Icons.circle,
                  color: theme,
                  size: 15,
                ),
              ],
            ),
            InkWell(
              // TODO: Implement Dashboard link
              onTap: () {},
              // Navigator.popAndPushNamed(context, DashBoard.routeName),
              child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: theme,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                      child: Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ))),
            )
          ],
        ),
      ),
    );
  }
}