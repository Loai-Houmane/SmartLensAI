import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:screenshot/screenshot.dart';

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String value = "";
  bool _isPersonDetected = false;
  AudioCache _audioCache = AudioCache();
  bool isplaying = false;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  ScreenshotController screenshotController = ScreenshotController();
  CameraController _controller;
  bool isCapturingScreenshot = false; // Added boolean flag
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _controller.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      // Any additional setup or state changes after camera initialization
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
    _audioCache.clearCache();
  }





  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(model: "assets/mobilenet_v1_1.0_224.tflite", labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(model: "assets/ssd_mobilenet.tflite", labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  void _playSound() {
    isplaying = true;
    _audioCache.play("mixkit-vintage-warning-alarm-990.mp3");

    Timer(Duration(milliseconds: 500), () {
      isplaying = false;
    });
  }

  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;

      if (_recognitions.isNotEmpty) {
        _isPersonDetected = _recognitions.any((r) => r["detectedClass"] == value && r["confidenceInClass"] >= 0.7);

        if (_recognitions[0]["detectedClass"] != null && _recognitions[0]["confidenceInClass"] >= 0.6) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Ensure the widget has been built before capturing the screenshot
            if (_scaffoldKey.currentContext != null && _scaffoldKey.currentWidget != null) {
              if (_controller.value.isInitialized && !isCapturingScreenshot) {
                isCapturingScreenshot = true;

                screenshotController.capture().then((Uint8List image) {
                  isCapturingScreenshot = false;
                }).catchError((error) {
                  print('Error capturing screenshot: $error');
                });
              }
            }
          });
        }

        if (_isPersonDetected && !isplaying) {
          _playSound();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    TextEditingController mycontroller = TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      body: _model == ""
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(49, 62, 130, 1),
                    Color.fromRGBO(34, 192, 195, 1),
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
                              Text(
                                "Machine",
                                style: TextStyle(color: Colors.white, fontSize: 40),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 60),
                                child: Text(
                                  "Learning",
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'assets/images/MLR1.png',
                              height: 120,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(31, 44, 52, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    child: const Text(ssd),
                                    onPressed: () => onSelect(ssd),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  RaisedButton(
                                    child: const Text(yolo),
                                    onPressed: () => onSelect(yolo),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: 15, left: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(color: Colors.red),
                                      onChanged: (text) {
                                        value = text;
                                      },
                                      controller: mycontroller,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                        labelText: 'Target',
                                        hintText: 'Enter the target',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Target set to"),
                                                content: Text(value),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Colors.blue,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(_recognitions == null ? [] : _recognitions, math.max(_imageHeight, _imageWidth), math.min(_imageHeight, _imageWidth), screen.height, screen.width, _model,
                    value),
              ],
            ),
    );
  }
}
