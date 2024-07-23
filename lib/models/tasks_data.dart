import 'package:flutter/cupertino.dart';
import 'package:mnistdigitrecognizer/Services/database_services.dart';
import 'package:mnistdigitrecognizer/models/task.dart';

class TasksData extends ChangeNotifier {
  List<Task> tasks = [];
  void addTask(String content, String message, String per) async {
    Task task = await DatabaseServices.addTask(content, message, per);
    tasks.add(task);
    notifyListeners();
  }
}
