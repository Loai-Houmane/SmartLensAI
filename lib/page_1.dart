import 'package:flutter/material.dart';

import 'Animation/FadeAnimation.dart';
import 'DigetRecognetion/screens/draw_screen.dart';

class Page1 extends StatelessWidget {
  const Page1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            height: 500,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 8,
                  blurRadius: 10,
                  offset: Offset(0, 8), // changes position of shadow
                ),
              ],
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   colors: [
              //     Color.fromRGBO(49, 62, 130, 1),
              //     // Color.fromRGBO(150, 28, 139, 1),
              //     Color.fromRGBO(34, 192, 195, 1),
              //     // Colors.green[100],
              //   ],
              // ),
              // color: Color.fromRGBO(23, 7, 43, 1),
              image: DecorationImage(
                image: AssetImage('assets/images/15408.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                new Align(
                  alignment: Alignment.center,
                  child: FadeAnimation(
                      0.5,
                      Text(
                        "Digit recognition",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )),
                ),
                SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrawScreen()));
                  },
                  child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeAnimation(
                      0.5,
                      Image.asset(
                        'assets/images/1.png',
                        width: 330,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
