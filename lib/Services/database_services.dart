import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:mnistdigitrecognizer/models/task.dart';

import 'globals.dart';

class DatabaseServices {
  static Future<Task> addTask(String content, String message, String per) async {
    Map data = {
      "content": content,
      "message": message,
      "per": per,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/message');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    Map responseMap = jsonDecode(response.body);
    Task task = Task.fromMap(responseMap);

    return task;
  }
}
