import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/Login.dart';
import 'package:flutter/services.dart';

List<CameraDescription> cameras;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mnist Digit Recognizer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.black,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
          ),
        ),
        home: login(cameras)
        // choosing()
        // DrawScreen(),
        );
  }
}
