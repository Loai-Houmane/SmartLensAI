import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mnistdigitrecognizer/static%20image/static.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

import 'models/tasks_data.dart';

Future<Image> convertFileToImage(File picture) async {
  List<int> imageBase64 = picture.readAsBytesSync();
  String imageAsString = base64Encode(imageBase64);
  Uint8List uint8list = base64.decode(imageAsString);
  Image image = Image.memory(uint8list);
  return image;
}

class ChatApplication extends StatefulWidget {
  @override
  _ChatApplicationState createState() => _ChatApplicationState();
}

class _ChatApplicationState extends State<ChatApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat only \nsend photos',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Avatar(
                        margin: EdgeInsets.only(right: 15),
                        image: 'assets/image/${index + 1}.jpg',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 35),
          physics: BouncingScrollPhysics(),
          children: [
            _itemChats(
              avatar: 'assets/image/2.jpg',
              name: 'Ahmed',
              chat: 'Hey, how\'s it going today?',
              time: '08.10',
            ),
            _itemChats(
              avatar: 'assets/image/4.jpg',
              name: 'Yassine',
              chat: 'I\'m running a bit late, I\'ll be there in 20 minutes',
              time: '03.19',
            ),
            _itemChats(
              avatar: 'assets/image/5.jpg',
              name: '3ami',
              chat: 'Hii... 😎',
              time: '02.53',
            ),
            _itemChats(
              avatar: 'assets/image/6.jpg',
              name: 'Nassiri',
              chat: 'Did you see the latest episode of that show we were watching?',
              time: '11.39',
            ),
            _itemChats(
              avatar: 'assets/image/7.jpg',
              name: 'Alexander',
              chat: 'Just wanted to remind you about our call at 3pm',
              time: '00.09',
            ),
            _itemChats(
              avatar: 'assets/image/8.jpg',
              name: 'Alsoher',
              chat: 'Did you catch the latest game last night?',
              time: '00.09',
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemChats({String avatar = '', name = '', chat = '', time = '00.00'}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatPage(),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        child: Row(
          children: [
            Avatar(
              margin: EdgeInsets.only(right: 20),
              size: 60,
              image: avatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$time',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$chat',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  File _image;
  List _recognitions;
  bool _busy;
  double _imageWidth, _imageHeight;

  final picker = ImagePicker();

  // this function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",

      // model: "assets/tflite/yolov2_tiny.tflite",
      // labels: "assets/tflite/yolov2_tiny.txt",
    );
  }

  detectObject1(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, // required
        model: "SSDMobileNet",
        // model: "yolov2_tiny",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4, // defaults to 0.1
        numResultsPerClass: 10, // defaults to 5
        asynch: true // defaults to true
        );
    FileImage(image).resolve(ImageConfiguration()).addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    setState(() {
      _recognitions = recognitions;
    });
    print(recognitions);
    content = recognitions[0]["detectedClass"];
    per = (recognitions[0]["confidenceInClass"] * 100).toString();
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadTfModel().then((val) {
      {
        setState(() {
          _busy = false;
        });
      }
    });
  }

  //!v*********************************
  String content = "ddd";
  String per = 'g';
  String image = "";

  File imageFile;
  File _imageFile;

  String _base64String = "1";
  Image img;

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _imageFile = imageFile;

        ToBase46();
      });
    }

    img = await convertFileToImage(imageFile);
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _imageFile = imageFile;

        ToBase46();
      });
    }
  }

  ToBase46() async {
    Uint8List _bytes = await _imageFile.readAsBytes();
    // base64 encode the bytes
    _base64String = base64.encode(_bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topChat(),
                _bodyChat(),
                SizedBox(
                  height: 120,
                )
              ],
            ),
            _formChat(),
          ],
        ),
      ),
    );
  }

  _topChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                'Ahmed',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.call,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.videocam,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bodyChat() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            _itemChat(
              avatar: 'assets/image/2.jpg',
              chat: 1,
              message: 'I\'m thinking of ordering pizza for dinner, what do you think?',
              time: '18.00',
            ),
            _itemChat(
              chat: 0,
              message: 'Okey 🐣',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/2.jpg',
              chat: 1,
              message: 'It has survived not only five centuries, 😀',
              time: '18.00',
            ),
            _itemChat(
              chat: 0,
              message: 'Contrary to popular belief, Lorem Ipsum is not simply random text. 😎',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/2.jpg',
              chat: 1,
              message: 'The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
              time: '18.00',
            ),
            _itemChat(
              avatar: 'assets/image/2.jpg',
              chat: 1,
              message: '😅 😂 🤣',
              time: '18.00',
            ),
            _itemChat1(),
          ],
        ),
      ),
    );
  }

  // 0 = Send
  // 1 = Recieved

  _itemChat({int chat, String avatar, message, time}) {
    return Row(
      mainAxisAlignment: chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        avatar != null
            ? Avatar(
                image: avatar,
                size: 50,
              )
            : Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade100 : Colors.indigo.shade50,
              borderRadius: chat == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
            ),
            child: Text('$message'),
          ),
        ),
        chat == 1
            ? Text(
                '$time',
                style: TextStyle(color: Colors.grey.shade400),
              )
            : SizedBox(),
      ],
    );
  }

  _itemChat1() {
    String avatar = 'ss';

    return _imageFile != null
        ? Row(
            mainAxisAlignment: 0 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )),
                  child: img,
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _formChat() {
    return ChangeNotifierProvider<TasksData>(
      create: (_) => TasksData(),
      builder: (context, child) {
        return Positioned(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  setState(() async {
                    await _getFromGallery();

                    await detectObject1(_imageFile);
                    Provider.of<TasksData>(context, listen: false).addTask(content, _base64String, per);
                  });
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.blue,
                  size: 28,
                ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       Provider.of<TasksData>(context, listen: false).addTask(content, _base64String, per);
                //       print(_base64String);
                //     });
                //   },
                //   child: Icon(
                //     Icons.send_rounded,
                //     color: Colors.blue,
                //     size: 28,
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     detectObject1(_imageFile);
                //   },
                //   child: Icon(
                //     Icons.expand,
                //     color: Colors.blue,
                //     size: 28,
                //   ),
              ),

              // child: TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Type your message...',
              //     suffixIcon: Container(
              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.indigo),
              //       padding: EdgeInsets.all(14),
              //       // child: Row(
              //       //   children: [
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         setState(() {
              //       //           _getFromGallery();

              //       //           print(_base64String);
              //       //         });
              //       //       },
              //       //       child: Icon(
              //       //         Icons.add_a_photo,
              //       //         color: Colors.white,
              //       //         size: 28,
              //       //       ),
              //       //     ),
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         setState(() {
              //       //           Provider.of<TasksData>(context, listen: false).addTask(content, _base64String, per);
              //       //           print(_base64String);
              //       //         });
              //       //       },
              //       //       child: Icon(
              //       //         Icons.send_rounded,
              //       //         color: Colors.white,
              //       //         size: 28,
              //       //       ),
              //       //     ),
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         detectObject1(_imageFile);
              //       //       },
              //       //       child: Icon(
              //       //         Icons.expand,
              //       //         color: Colors.white,
              //       //         size: 28,
              //       //       ),
              //       //     ),
              //       //   ],
              //       // ),
              //     ),
              //     filled: true,
              //     fillColor: Colors.blueGrey[50],
              //     labelStyle: TextStyle(fontSize: 12),
              //     contentPadding: EdgeInsets.all(20),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blueGrey[50]),
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blueGrey[50]),
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //   ),
              // ),
            ),
          ),
        );
      },
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
