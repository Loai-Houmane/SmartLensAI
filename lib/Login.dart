import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'page_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Animation/FadeAnimation.dart';
import 'page_1.dart';
import 'page_2.dart';

// ignore: camel_case_types
class login extends StatelessWidget {
  final List<CameraDescription> cameras;

  login(this.cameras);
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(49, 62, 130, 1),
              // Color.fromRGBO(150, 28, 139, 1),
              Color.fromRGBO(34, 192, 195, 1),
              // Colors.green[100],
            ],
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Text(
                              "Machine",
                              style: TextStyle(color: Colors.white, fontSize: 40),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.3,
                            Padding(
                              padding: EdgeInsets.only(left: 60),
                              child: Text(
                                "Learning",
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            )),
                      ],
                    ),
                    // Positioned(
                    // width: MediaQuery.of(context).size.width,
                    // right: MediaQuery.of(context).size.width * 1,

                    Container(
                      alignment: Alignment.centerRight,
                      // color: Colors.black54,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/MLR1.png',
                        height: 120,
                        // width: 150,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(150, 28, 139, 1),
                    color: Color.fromRGBO(31, 44, 52, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    // Add this
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 40,),
                        // page view
                        SizedBox(
                          height: 500,
                          child: PageView(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            controller: _controller,
                            children: [
                              Page1(),
                              Page2(),
                              Page3(cameras),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // dot indicators
                        SmoothPageIndicator(
                          controller: _controller,
                          count: 3,
                          effect: JumpingDotEffect(
                            activeDotColor: Color.fromRGBO(41, 134, 167, 1),
                            dotColor: Colors.deepPurple.shade100,
                            dotHeight: 10,
                            dotWidth: 10,
                            spacing: 30,
                            verticalOffset: 30,
                            jumpScale: 3,
                          ),
                        ),
                      ],
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
