import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/DigetRecognetion/models/prediction.dart';
import 'package:mnistdigitrecognizer/DigetRecognetion/screens/prediction_widget.dart';
import 'package:mnistdigitrecognizer/DigetRecognetion/services/recognizer.dart';
import 'package:mnistdigitrecognizer/DigetRecognetion/utils/constants.dart';

import 'drawing_painter.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final _recognizer = Recognizer();
  List<Prediction> _prediction;
  bool initialize = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digit Recognizer',
        ),
      ),
      body: Container(
        color: Color.fromRGBO(31, 44, 52, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            _mnistPreviewImage(),
            SizedBox(
              height: 10,
            ),
            _drawCanvasWidget(),
            SizedBox(
              height: 10,
            ),
            PredictionWidget(
              predictions: _prediction,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _points.clear();
            _prediction.clear();
          });
        },
      ),
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/board.png'),
          fit: BoxFit.fill,
        ),
        // border: Border.all(
        //   color: Colors.blue[800],
        //   width: Constants.borderSize,
        // ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 25 && _localPosition.dx <= Constants.canvasSize - 8 && _localPosition.dy >= 20 && _localPosition.dy <= Constants.canvasSize - 15) {
            setState(() {
              _points.add(_localPosition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _mnistPreviewImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data,
              fit: BoxFit.fill,
            );
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
  }
}
