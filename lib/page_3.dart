import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Animation/FadeAnimation.dart';
import 'NOD/home.dart';

class Page3 extends StatelessWidget {
  final List<CameraDescription> cameras;

  Page3(this.cameras);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
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
                      "Real-time",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
              ),
              new Align(
                alignment: Alignment.center,
                child: FadeAnimation(
                    0.5,
                    Text(
                      "Object Detection",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(cameras)));
                },
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeAnimation(
                    0.5,
                    Image.asset(
                      'assets/images/camera.png',
                      width: 230,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
